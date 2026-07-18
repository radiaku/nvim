-- Guard: don't attach LSP to buffers whose file is missing on disk
-- (e.g. opened from oldfiles/session after being deleted outside nvim).
-- Covers both Mason and direct setups: every lspconfig server attaches
-- through manager:try_add, and all manager instances share methods via
-- __index on the module table, so one patch gates them all.
--
-- Also owns external-change handling: defining FileChangedShell disables
-- Neovim's default autoread path, so this must auto-reload unmodified
-- buffers and never spam prompts when many files change (Claude, etc.).
--
-- Session/bulk open: only the focused buffer attaches LSP immediately;
-- others wait for BufEnter so large workspaces don't start N servers at once.
local M = {}

-- True for a normal file buffer whose path no longer exists on disk
local function file_missing(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	if vim.bo[bufnr].buftype ~= "" then
		return false
	end
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return false
	end
	return vim.fn.filereadable(name) == 0
end

function M.setup()
	if vim.g.__radia_lsp_guard then
		return
	end
	vim.g.__radia_lsp_guard = true

	local ok, manager = pcall(require, "lspconfig.manager")
	if ok then
		local try_add = manager.try_add
		---@diagnostic disable-next-line: duplicate-set-field
		function manager:try_add(bufnr, project_root, silent)
			bufnr = bufnr or vim.api.nvim_get_current_buf()
			if file_missing(bufnr) then
				vim.b[bufnr].radia_lsp_deferred = true
				return
			end
			-- Bulk open / session restore: only attach to the focused buffer.
			if bufnr ~= vim.api.nvim_get_current_buf() then
				vim.b[bufnr].radia_lsp_focus_deferred = true
				return
			end
			return try_add(self, bufnr, project_root, silent)
		end
	end

	local group = vim.api.nvim_create_augroup("RadiaLspGuard", { clear = true })

	-- Attach LSP when the user actually visits a deferred buffer (debounced).
	local focus_pending = false
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		desc = "Start LSP for buffers deferred during bulk open",
		callback = function(args)
			local buf = args.buf
			if not vim.b[buf].radia_lsp_focus_deferred then
				return
			end
			if file_missing(buf) then
				return
			end
			if focus_pending then
				return
			end
			focus_pending = true
			vim.defer_fn(function()
				focus_pending = false
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				if not vim.b[buf].radia_lsp_focus_deferred then
					return
				end
				if buf ~= vim.api.nvim_get_current_buf() then
					return
				end
				vim.b[buf].radia_lsp_focus_deferred = nil
				vim.api.nvim_buf_call(buf, function()
					pcall(vim.cmd, "LspStart")
				end)
			end, 80)
		end,
	})

	-- Batch external-change notices so multi-file edits don't flood the UI.
	-- Use defer_fn (not uv timers) — stop/close/recreate races produce red
	-- "Error executing luv callback" storms that block input.
	local pending = { reloaded = 0, deleted = 0, conflict = 0 }
	local notify_scheduled = false

	local function flush_notice()
		notify_scheduled = false
		local parts = {}
		if pending.reloaded > 0 then
			parts[#parts + 1] = pending.reloaded .. " reloaded"
		end
		if pending.deleted > 0 then
			parts[#parts + 1] = pending.deleted .. " deleted (kept)"
		end
		if pending.conflict > 0 then
			parts[#parts + 1] = pending.conflict .. " conflict (kept local)"
		end
		pending.reloaded, pending.deleted, pending.conflict = 0, 0, 0
		if #parts == 0 then
			return
		end
		pcall(vim.notify, "Disk change: " .. table.concat(parts, ", "), vim.log.levels.INFO)
	end

	local function queue_notice(kind)
		pending[kind] = (pending[kind] or 0) + 1
		if notify_scheduled then
			return
		end
		notify_scheduled = true
		vim.defer_fn(flush_notice, 250)
	end

	-- Defining FileChangedShell disables default autoread handling, so every
	-- reason must set v:fcs_choice. Unmodified external edits → silent reload
	-- (no per-file prompt storm when Claude rewrites many open buffers).
	vim.api.nvim_create_autocmd("FileChangedShell", {
		group = group,
		desc = "Auto-reload external edits; quiet deleted-file E211",
		callback = function(args)
			local reason = vim.v.fcs_reason
			local buf = args.buf
			local modified = vim.bo[buf].modified

			if reason == "deleted" then
				-- Keep buffer + LSP; :w recreates the file. Suppress E211.
				vim.v.fcs_choice = ""
				vim.bo[buf].modified = true
				queue_notice("deleted")
				return
			end

			-- conflict: buffer dirty AND disk changed — never clobber local work
			if reason == "conflict" or modified then
				vim.v.fcs_choice = ""
				queue_notice("conflict")
				return
			end

			-- changed / mode / time on a clean buffer → reload from disk
			vim.v.fcs_choice = "reload"
			queue_notice("reloaded")
		end,
	})

	-- Detect disk changes when returning from terminal/other apps.
	-- Guard against insert/cmdline and re-entrancy so checktime never storms.
	local checking = false
	local function safe_checktime(all_buffers)
		if checking then
			return
		end
		local mode = vim.fn.mode()
		if mode:find("[iRct]") ~= nil then
			return
		end
		checking = true
		vim.schedule(function()
			if all_buffers then
				pcall(vim.cmd, "checktime")
			else
				-- CursorHold: only current buffer (full checktime stats every open file)
				pcall(vim.cmd, "checktime " .. vim.api.nvim_get_current_buf())
			end
			checking = false
		end)
	end

	vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
		group = group,
		desc = "checktime after focus/terminal so external edits are detected",
		callback = function()
			safe_checktime(true)
		end,
	})

	-- Lightweight poll while idle (covers GUIs/terminals that miss FocusGained)
	vim.api.nvim_create_autocmd("CursorHold", {
		group = group,
		desc = "Periodic checktime for current buffer only",
		callback = function()
			safe_checktime(false)
		end,
	})

	-- Once the file exists on disk (first save of a new/re-created file),
	-- start the servers that were skipped above.
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		desc = "Start LSP once a previously-missing file exists on disk",
		callback = function(args)
			if vim.b[args.buf].radia_lsp_deferred and not file_missing(args.buf) then
				vim.b[args.buf].radia_lsp_deferred = nil
				vim.api.nvim_buf_call(args.buf, function()
					vim.cmd("LspStart")
				end)
			end
		end,
	})
end

return M

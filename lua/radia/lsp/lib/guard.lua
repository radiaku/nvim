-- Guard for Neovim 0.12+ (vim.lsp.config / vim.lsp.start).
--
-- 1) Don't start LSP on buffers whose file is missing on disk
-- 2) During bulk open / session restore, only attach the focused buffer;
--    others wait for BufEnter (stashed start args are replayed)
-- 3) External disk changes (Claude/CommandCode): auto-reload clean buffers,
--    keep dirty ones, suppress E211, batch notify — never spam red errors
local M = {}

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

	-- Patch native start (0.12 path). Keep a soft fallback for lspconfig.manager
	-- if an older plugin still routes through it.
	local original_start = vim.lsp.start
	---@type table<integer, {config: table, opts: table}[]>
	local deferred_starts = {}

	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.start = function(config, opts)
		opts = opts or {}
		local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

		if file_missing(bufnr) then
			vim.b[bufnr].radia_lsp_deferred = true
			return nil
		end

		-- Bulk open: only the focused buffer starts immediately
		if bufnr ~= vim.api.nvim_get_current_buf() then
			deferred_starts[bufnr] = deferred_starts[bufnr] or {}
			deferred_starts[bufnr][#deferred_starts[bufnr] + 1] = {
				config = config,
				opts = opts,
			}
			vim.b[bufnr].radia_lsp_focus_deferred = true
			return nil
		end

		return original_start(config, opts)
	end

	local ok_mgr, manager = pcall(require, "lspconfig.manager")
	if ok_mgr and manager and type(manager.try_add) == "function" then
		local try_add = manager.try_add
		---@diagnostic disable-next-line: duplicate-set-field
		function manager:try_add(bufnr, project_root, silent)
			bufnr = bufnr or vim.api.nvim_get_current_buf()
			if file_missing(bufnr) then
				vim.b[bufnr].radia_lsp_deferred = true
				return
			end
			if bufnr ~= vim.api.nvim_get_current_buf() then
				vim.b[bufnr].radia_lsp_focus_deferred = true
				return
			end
			return try_add(self, bufnr, project_root, silent)
		end
	end

	local group = vim.api.nvim_create_augroup("RadiaLspGuard", { clear = true })

	local focus_pending = false
	local function replay_deferred(buf)
		local items = deferred_starts[buf]
		deferred_starts[buf] = nil
		vim.b[buf].radia_lsp_focus_deferred = nil
		if not items or #items == 0 then
			-- No stashed configs (e.g. manager path) — re-fire FileType so
			-- vim.lsp.enable autocmds try again on this focused buffer.
			local ft = vim.bo[buf].filetype
			if ft and ft ~= "" then
				pcall(vim.api.nvim_exec_autocmds, "FileType", {
					buffer = buf,
					modeline = false,
					data = { filetype = ft },
				})
			end
			return
		end
		for _, item in ipairs(items) do
			local o = vim.tbl_extend("force", {}, item.opts or {})
			o.bufnr = buf
			pcall(original_start, item.config, o)
		end
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		desc = "Start LSP for buffers deferred during bulk open",
		callback = function(args)
			local buf = args.buf
			if not vim.b[buf].radia_lsp_focus_deferred and not deferred_starts[buf] then
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
				if buf ~= vim.api.nvim_get_current_buf() then
					return
				end
				if file_missing(buf) then
					return
				end
				replay_deferred(buf)
			end, 80)
		end,
	})

	-- Batch external-change notices (defer_fn — not uv timers; avoids luv storms)
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

	-- Defining FileChangedShell disables default autoread — always set fcs_choice
	vim.api.nvim_create_autocmd("FileChangedShell", {
		group = group,
		desc = "Auto-reload external edits; quiet deleted-file E211",
		callback = function(args)
			local reason = vim.v.fcs_reason
			local buf = args.buf
			local modified = vim.bo[buf].modified

			if reason == "deleted" then
				vim.v.fcs_choice = ""
				vim.bo[buf].modified = true
				queue_notice("deleted")
				return
			end

			if reason == "conflict" or modified then
				vim.v.fcs_choice = ""
				queue_notice("conflict")
				return
			end

			vim.v.fcs_choice = "reload"
			queue_notice("reloaded")
		end,
	})

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

	vim.api.nvim_create_autocmd("CursorHold", {
		group = group,
		desc = "Periodic checktime for current buffer only",
		callback = function()
			safe_checktime(false)
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		desc = "Start LSP once a previously-missing file exists on disk",
		callback = function(args)
			local buf = args.buf
			if not vim.b[buf].radia_lsp_deferred then
				return
			end
			if file_missing(buf) then
				return
			end
			vim.b[buf].radia_lsp_deferred = nil
			local ft = vim.bo[buf].filetype
			if ft and ft ~= "" then
				pcall(vim.api.nvim_exec_autocmds, "FileType", {
					buffer = buf,
					modeline = false,
					data = { filetype = ft },
				})
			end
		end,
	})

	-- Drop stashed starts when buffer goes away
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		callback = function(args)
			deferred_starts[args.buf] = nil
		end,
	})
end

return M

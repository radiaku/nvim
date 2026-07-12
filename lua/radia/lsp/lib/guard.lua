-- Guard: don't attach LSP to buffers whose file is missing on disk
-- (e.g. opened from oldfiles/session after being deleted outside nvim).
-- Covers both Mason and direct setups: every lspconfig server attaches
-- through manager:try_add, and all manager instances share methods via
-- __index on the module table, so one patch gates them all.
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
			return try_add(self, bufnr, project_root, silent)
		end
	end

	local group = vim.api.nvim_create_augroup("RadiaLspGuard", { clear = true })

	-- File deleted on disk while the buffer (and LSP) is open: keep both,
	-- silently. Attached servers work from buffer content, and :w recreates
	-- the file. Handling "deleted" ourselves suppresses the E211 error;
	-- every other reason falls through to default behavior via "ask".
	vim.api.nvim_create_autocmd("FileChangedShell", {
		group = group,
		desc = "Deleted on disk: keep buffer and LSP quietly instead of E211",
		callback = function(args)
			if vim.v.fcs_reason ~= "deleted" then
				vim.v.fcs_choice = "ask"
				return
			end
			vim.v.fcs_choice = ""
			-- mirror the default: don't let an unsaved buffer look clean
			vim.bo[args.buf].modified = true
			local name = vim.fn.fnamemodify(args.file, ":~:.")
			vim.schedule(function()
				vim.notify(("File deleted on disk; buffer kept, :w recreates it: %s"):format(name), vim.log.levels.WARN)
			end)
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

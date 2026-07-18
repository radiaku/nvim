return {
	"rmagatti/auto-session",
	commit = "095b0b",
	event = "VimEnter",
	config = function()
		-- Cap hidden restored buffers so large workspaces don't re-open 100+ files
		-- (each one would trigger treesitter/LSP/format plugin attach).
		local MAX_HIDDEN_BUFFERS = 8

		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = {
				"~/", "~/projects", "~/Downloads", "/",
				vim.fn.stdpath("config"), -- skip session restore for nvim config dir
			},
			pre_save_cmds = { "tabdo Neotree close" },
			post_restore_cmds = {
				function()
					-- 1) Wipe phantom buffers (deleted on disk, empty [New])
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if
							vim.api.nvim_buf_is_valid(buf)
							and vim.bo[buf].buflisted
							and vim.bo[buf].buftype == ""
							and not vim.bo[buf].modified
						then
							local name = vim.api.nvim_buf_get_name(buf)
							if name ~= "" and vim.fn.filereadable(name) == 0 then
								pcall(vim.api.nvim_buf_delete, buf, {})
							end
						end
					end

					-- 2) Keep every buffer visible in a window; cap the rest.
					--    Prevents monorepo sessions from re-opening the whole tree.
					local visible = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						visible[vim.api.nvim_win_get_buf(win)] = true
					end

					local hidden = {}
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if
							vim.api.nvim_buf_is_valid(buf)
							and vim.bo[buf].buflisted
							and vim.bo[buf].buftype == ""
							and not visible[buf]
							and not vim.bo[buf].modified
						then
							hidden[#hidden + 1] = buf
						end
					end

					-- Prefer more recently used buffers (higher lastused)
					table.sort(hidden, function(a, b)
						local ia = vim.fn.getbufinfo(a)[1]
						local ib = vim.fn.getbufinfo(b)[1]
						return (ia and ia.lastused or 0) > (ib and ib.lastused or 0)
					end)

					for i = MAX_HIDDEN_BUFFERS + 1, #hidden do
						pcall(vim.api.nvim_buf_delete, hidden[i], {})
					end
				end,
			},
		})

		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
	end,
}

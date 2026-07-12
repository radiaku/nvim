return {
	"rmagatti/auto-session",
	commit = "095b0b",
	event = "VimEnter",
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = {
				"~/", "~/projects", "~/Downloads", "/",
				vim.fn.stdpath("config"), -- skip session restore for nvim config dir
			},
			pre_save_cmds = { "tabdo Neotree close" },
			post_restore_cmds = {
				-- Wipe phantom buffers: files deleted outside nvim restore as
				-- empty [New] buffers; drop them unless they hold unsaved edits
				function()
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
				end,
			},
		})

		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
	end,
}

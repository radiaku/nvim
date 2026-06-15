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
			-- post_restore_cmds = {"Neotree"}
		})

		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
	end,
}

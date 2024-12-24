return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/projects", "~/Downloads", "/" },
			pre_save_cmds = { "tabdo Neotree close" },
			-- post_restore_cmds = {"Neotree"}
		})

		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
	end,
}

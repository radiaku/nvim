return {
	"pysan3/autosession.nvim",
	event = { "VeryLazy" },
	dependencies = { "mhinz/vim-startify" },
	opts = {
		-- Options explained below.
	},
	config = function()
		require("autosession").setup({
			msg = nil,
			restore_on_setup = true,
			warn_on_setup = false,
			autosave_on_quit = true,
			save_session_global_dir = vim.g.startify_session_dir or vim.fn.stdpath("data") .. "/session",
			sessionfile_name = ".session.vim",
			disable_envvar = "NVIM_DISABLE_AUTOSESSION",
		})
	end,
}

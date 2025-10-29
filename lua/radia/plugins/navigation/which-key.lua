return {
	"folke/which-key.nvim",
	commit = "370ec4",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
}

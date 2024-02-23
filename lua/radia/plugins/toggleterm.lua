return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup()
		vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm<CR>", { noremap = true })
		-- vim.api.nvim_set_keymap("t", "<C-T>", ":ToggleTerm<CR>", { noremap = true })
	end,
}

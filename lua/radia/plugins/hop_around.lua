return {
	"phaazon/hop.nvim",
	branch = "v2", -- optional but strongly recommended
	config = function()
		-- you can configure Hop the way you like here; see :h hop-config
		require("hop").setup({ keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5 })
		vim.api.nvim_set_keymap("", "f", "<cmd>lua require'hop'.hint_char1()<cr>", {})
		vim.api.nvim_set_keymap("n", "t", "<cmd>HopPattern<CR>", { noremap = true })
	end,
}

return {
	"smoka7/hop.nvim",
	commit = "9c6a1d",
	config = function()
		-- you can configure Hop the way you like here; see :h hop-config
		require("hop").setup({ keys = "etovxqpdygfblzhckisuran", term_seq_bias = 0.5 })
		-- vim.api.nvim_set_keymap("n", "f", "<cmd>lua require'hop'.hint_char1()<cr>", {})
	end,
}

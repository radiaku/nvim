return {
	"spacedentist/resolve.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {},

	config = function()
		-- require("resolve").setup({
		-- 	default_keymaps = false,
		-- })
	end,
}

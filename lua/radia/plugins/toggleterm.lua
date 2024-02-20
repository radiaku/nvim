return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup()
	end,
	-- keys = {
	-- 	{
	-- 		"<leader>td",
	-- 		":ToggleTerm<CR><CR>",
	-- 		desc = "Open a horizontal terminal at the Desktop directory",
	-- 	},
	-- },
}

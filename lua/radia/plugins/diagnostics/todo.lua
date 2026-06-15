return {
	"folke/todo-comments.nvim",
	commit = "304a8d",
	event = "VeryLazy",
	config = function()
		require("todo-comments").setup()
	end,
}

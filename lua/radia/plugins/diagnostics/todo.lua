return {
	"folke/todo-comments.nvim",
	-- Don't scan the whole monorepo on first open; load on demand.
	cmd = { "TodoTrouble", "TodoTelescope", "TodoQuickFix", "TodoLocList" },
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
	},
	config = function()
		require("todo-comments").setup({
			highlight = {
				comments_only = true,
			},
		})
	end,
}

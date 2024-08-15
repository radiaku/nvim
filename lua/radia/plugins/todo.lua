return {
	"folke/todo-comments.nvim",
	config = function()
		require("todo-comments").setup()
		vim.api.nvim_set_keymap("n", "<leader>td", ":TodoTelescope<CR>", { noremap = true, desc = "TodoTelescope" })
		vim.api.nvim_set_keymap("n", "<leader>tq", ":TodoQuickFix<CR>", { noremap = true, desc = "TodoQuickFix" })
	end,
}

return {
	"crusj/bookmarks.nvim",
	keys = {
		{ "<tab><tab>", mode = { "n" } },
	},
	branch = "main",
	dependencies = { "nvim-web-devicons" },
	config = function()
		require("bookmarks").setup({
			keymap = {
				toggle = "<tab><tab>",
				add = "\\z",
				delete = "dd",
				delete_on_virt = "\\dd",
			},
		})
		require("telescope").load_extension("bookmarks")
	end,
}

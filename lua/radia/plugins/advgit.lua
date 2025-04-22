return {
	"aaronhallaert/advanced-git-search.nvim",
	cmd = { "AdvancedGitSearch" },
	config = function()
		-- optional: setup telescope before loading the extension
		require("telescope").setup({
			-- move this to the place where you call the telescope setup function
			extensions = {
				advanced_git_search = {
					-- See Config
				},
			},
		})

		require("telescope").load_extension("advanced_git_search")
	end,
	dependencies = {
		--- See dependencies
    "tpope/vim-fugitive",
    -- to open commits in browser with fugitive
    -- "tpope/vim-rhubarb",
    "sindrets/diffview.nvim",
	},
}

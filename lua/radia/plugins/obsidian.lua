return {
	{
		"epwalsh/obsidian.nvim",
		event = "VeryLazy",
		-- lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("obsidian").setup({
				workspaces = {
					{
						name = "personal",
						path = "~/Documents/ObsidianVault",
					},
				},
				ui = { enable = false },
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			latex = {
				enabled = false,
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	},
}

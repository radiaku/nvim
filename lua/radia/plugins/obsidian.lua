local obsidian_vault_path = vim.fn.expand("~/Documents/ObsidianVault")

-- Check if the directory exists
if vim.fn.isdirectory(obsidian_vault_path) == 1 then
	return {
		{
			"epwalsh/obsidian.nvim",
			commit = "bb25ae",
			event = "VeryLazy",
			ft = "markdown",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("obsidian").setup({
					workspaces = {
						{
							name = "personal",
							path = obsidian_vault_path,
						},
					},
					ui = { enable = false },
				})
			end,
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			commit = "8bb0d4",
			opts = {
				latex = {
					enabled = false,
				},
			},
			dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
		},
	}
else
	return {}
end

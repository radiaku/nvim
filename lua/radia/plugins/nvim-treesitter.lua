return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		-- build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = {
					enable = false,
				},
				disable = function()
					return string.len(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "")) > 100000
				end,
				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					"javascript",
					"html",
					"css",
					"bash",
					"lua",
					"vim",
					"gitignore",
					"query",
				},
				incremental_selection = {
					enable = false,
					-- keymaps = {
					-- 	init_selection = "<C-space>",
					-- 	node_incremental = "<C-space>",
					-- 	scope_incremental = false,
					-- 	node_decremental = "<bs>",
					-- },
				},
			})

			-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
			-- require("ts_context_commentstring").setup({})
		end,
	},
}

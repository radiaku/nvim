return {
	{
		"nvim-treesitter/nvim-treesitter",
		commit = "7bbed4",
		event = { "BufReadPre", "BufNewFile" },
		-- build = ":TSUpdate",
		dependencies = {
			{ "windwp/nvim-ts-autotag", commit = "a1d526" },
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- configure treesitter
			treesitter.setup({
				-- enable syntax highlighting
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
					return string.len(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "")) > 500000
				end,
				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					"javascript",
					"html",
					"go",
					"php",
					"python",
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
				textobjects = {
					select = {
						enable = true,

						lookahead = true,

						keymaps = {

							-- ["sa"] = { query = "@attribute.outer", desc = "Select outer part of a assignment" },
							-- ["si"] = { query = "@attribute.inner", desc = "Select inner part of a assignment" },
							--
							-- ["ta"] = { query = "@attribute.outer", desc = "Select outer part of a attribute" },
							-- ["ti"] = { query = "@attribute.inner", desc = "Select inner part of a attribute" },

							-- ["ga"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
							-- ["gi"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

							["ab"] = { query = "@block.outer", desc = "Select outer part of a block" },
							["ib"] = { query = "@block.inner", desc = "Select inner part of a block" },

							["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
							["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

							["ac"] = {
								query = "@conditional.outer",
								desc = "Select outer part of a conditional definition",
							},
							["ic"] = {
								query = "@conditional.inner",
								desc = "Select inner part of a conditional definition",
							},

							["af"] = {
								query = "@function.outer",
								desc = "Select outer part of a method/function definition",
							},
							["if"] = {
								query = "@function.inner",
								desc = "Select inner part of a method/function definition",
							},
						},
					},
				},
			})

			-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
			-- require("ts_context_commentstring").setup({})
		end,
	},
}

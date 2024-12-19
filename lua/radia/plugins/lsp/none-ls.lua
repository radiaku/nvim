return {
	"nvimtools/none-ls.nvim", -- configure formatters & linters
	lazy = true,
	-- event = { "BufReadPre", "BufNewFile" }, -- to enable uncomment this
	dependencies = {
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local mason_null_ls = require("mason-null-ls")
		local null_ls = require("null-ls")
		local null_ls_utils = require("null-ls.utils")
		local util = require("lspconfig/util")

		mason_null_ls.setup({
			automatic_installation = true,
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"black", -- python formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
			},
		})

		-- for conciseness
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

		-- to setup format on save
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		-- configure null_ls
		null_ls.setup({
			-- add package.json as identifier for root (for typescript monorepos)
			root_dir = null_ls_utils.find_git_ancestor,
			-- setup formatters & linters
			sources = {
				-- null_ls.builtins.completion.spell,
				-- deleted to fix luasnip and nvim-cmp duplications and errors
				-- null_ls.builtins.completion.luasnip,

				-- null_ls.builtins.diagnostics.checkmake,
				null_ls.builtins.diagnostics.commitlint,
				-- null_ls.builtins.diagnostics.cppcheck,
				null_ls.builtins.diagnostics.pylint,
				-- null_ls.builtins.diagnostics.trivy,
				-- null_ls.builtins.diagnostics.eslint_d,
				-- null_ls.builtins.diagnostics.markdownlint,

				null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.formatting.isortd,
				null_ls.builtins.formatting.blackd,
				null_ls.builtins.formatting.clang_format,
				-- null_ls.builtins.formatting.markdownlint,
				null_ls.builtins.formatting.prettierd,

				-- null_ls.builtins.hover.printenv,
				formatting.stylua, -- lua formatter
				-- formatting.isort,
				formatting.black,
				diagnostics.pylint.with({
				  extra_args = { "--disable", "c0114,c0115,c0116,c0301,w1203,w0703, W0511, C0321" },
				}),
				diagnostics.eslint_d.with({ -- js/ts linter
				  condition = function(utils)
				    return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
				  end,
				}),
			},

			-- configure autoformat on save
			on_attach = function(current_client, bufnr)
				if current_client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								filter = function(client)
									--  only use null-ls for formatting instead of lsp server
									return client.name == "null-ls"
								end,
								bufnr = bufnr,
							})
						end,
					})
				end
			end,
		})
	end,
}

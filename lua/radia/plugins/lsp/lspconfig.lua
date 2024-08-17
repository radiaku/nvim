return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		-- { "folke/neodev.nvim", opts = {} },
		{ "folke/lazydev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")

		-- import mason_lspconfig plugin
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["pyright"] = function()
				local python_root_files = {
					"WORKSPACE", -- added for Bazel; items below are from default config
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
				}

				local site_packages_path = ""
				local python_install_path = ""
				if vim.fn.has("win32") == 1 then
					python_install_path = vim.fn.exepath("python")
					local python_directory = python_install_path:match("(.*)\\[^\\]*$")
					site_packages_path = python_directory .. "\\lib\\site-packages"
				else
					python_install_path = vim.fn.exepath("python3")
				end

				lspconfig["pyright"].setup({
					filetypes = { "python", ".py" },
					capabilities = capabilities,

					root_dir = function(fname)
						table.unpack = table.unpack or unpack -- 5.1 compatibility
						return util.root_pattern(table.unpack(python_root_files))(fname)
							or util.find_git_ancestor(fname)
							or util.path.dirname(fname)
					end,
					settings = {
						pyright = {
							typeCheckingMode = "off",
							args = { "--select", "ALL", "--ignore", "D100" },
							extraPaths = { site_packages_path },
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							diagnosticSeverityOverrides = {
								reportUnknownVariableType = false,
								strictListInference = "error",
								strictDictionaryInference = "error",
								strictSetInference = "error",
								-- reportDuplicateImport = "error",
							},
						},
					},
				})
			end,



			-- ["basedpyright"] = function()
			-- 	local python_root_files = {
			-- 		"WORKSPACE", -- added for Bazel; items below are from default config
			-- 		"pyproject.toml",
			-- 		"setup.py",
			-- 		"setup.cfg",
			-- 		"requirements.txt",
			-- 		"Pipfile",
			-- 	}
			--
			-- 	local site_packages_path = ""
			-- 	local python_install_path = ""
			-- 	if vim.fn.has("win32") == 1 then
			-- 		python_install_path = vim.fn.exepath("python")
			-- 		local python_directory = python_install_path:match("(.*)\\[^\\]*$")
			-- 		site_packages_path = python_directory .. "\\lib\\site-packages"
			-- 	else
			-- 		python_install_path = vim.fn.exepath("python3")
			-- 	end
			--
			-- 	lspconfig["basedpyright"].setup({
			-- 		filetypes = { "python", ".py" },
			-- 		capabilities = capabilities,
			--
			-- 		root_dir = function(fname)
			-- 			table.unpack = table.unpack or unpack -- 5.1 compatibility
			-- 			return util.root_pattern(table.unpack(python_root_files))(fname)
			-- 				or util.find_git_ancestor(fname)
			-- 				or util.path.dirname(fname)
			-- 		end,
			-- 		settings = {
			-- 			basedpyright = {
			-- 				typeCheckingMode = "off",
			-- 				args = { "--select", "ALL", "--ignore", "D100" },
			-- 				extraPaths = { site_packages_path },
			-- 				autoSearchPaths = true,
			-- 				diagnosticMode = "workspace",
			-- 				useLibraryCodeForTypes = true,
			-- 				diagnosticSeverityOverrides = {
			-- 					reportUnknownVariableType = false,
			-- 					strictListInference = "error",
			-- 					strictDictionaryInference = "error",
			-- 					strictSetInference = "error",
			-- 					-- reportDuplicateImport = "error",
			-- 				},
			-- 			},
			-- 		},
			-- 	})
			-- end,

			["tsserver"] = function()
				lspconfig["tsserver"].setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["tailwindcss"] = function()
				lspconfig["tailwindcss"].setup({
					filetypes = {
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					autoformat = false,
					-- cmd = { bin_path .. "tailwindcss-language-server.cmd" },
				})
			end,

			["gopls"] = function()
				lspconfig["gopls"].setup({
					filetypes = { "go" },
					capabilities = capabilities,
				})
			end,

			["intelephense"] = function()
				lspconfig["intelephense"].setup({
					capabilities = capabilities,
					filetypes = { "php" },
					root_dir = function(pattern)
						local cwd = vim.fn.getcwd()
						local root = util.root_pattern("composer.json", ".git")(pattern)
						return util.path.is_descendant(cwd, root) and cwd or root
					end,
				})
			end,

			["html"] = function()
				lspconfig["html"].setup({
					filetypes = {
						"html",
						"*.tmpl",
						"gotexttmpl",
					},
					capabilities = capabilities,
					init_options = {
						embeddedLanguages = {
							css = true,
							javascript = true,
						},
						provideFormatter = true,
					},

					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					autoformat = false,
					-- cmd = { bin_path .. "vscode-html-language-server.cmd" },
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							-- completion = {
							-- 	callSnippet = "Replace",
							-- },
						},
					},
				})
			end,
		})
	end,
}

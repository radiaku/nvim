local blink_ok, blink = pcall(require, "blink.cmp")
return {
	"neovim/nvim-lspconfig",
	commit = "62c5fac4c59be9e41b92ef62f3bb0fbdae3e2d9e",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		(not blink_ok) and { "hrsh7th/cmp-nvim-lsp", commit = "a8912b" } or nil,
		-- "hrsh7th/cmp-nvim-lsp",
		-- "williamboman/mason-lspconfig.nvim",
		-- { "antosha417/nvim-lsp-file-operations", config = true },
		-- { "folke/neodev.nvim", opts = {} },
		-- { "folke/lazydev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")

		-- import mason_lspconfig plugin
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- Detect Termux (Android) environment
		local is_termux = false
		local prefix = vim.env.PREFIX or ""
		if prefix:find("com%.termux") then
			is_termux = true
		end

		-- import cmp-nvim-lsp plugin
		-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities
		-- used to enable autocompletion (assign to every lsp server config)
		-- local capabilities = cmp_nvim_lsp.default_capabilities()
		-- local capabilities = require("blink.cmp").get_lsp_capabilities()
		if blink_ok then
			capabilities = blink.get_lsp_capabilities()
		else
			local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if cmp_ok then
				capabilities = cmp_nvim_lsp.default_capabilities()
			else
				error("Neither 'blink.cmp' nor 'cmp_nvim_lsp' could be loaded.")
			end
		end

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- local server_namepy = vim.fn.has("win32") == 1 and "pyright" or "basedpyright"
		local server_namepy = "basedpyright"
		mason_lspconfig.setup_handlers({
			function(server_name)
				-- https://github.com/neovim/nvim-lspconfig/pull/3232
				-- server_name = server_name == "tsserver" and "ts_ls" or server_name
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			[server_namepy] = function()
				local python_root_files = {
					"WORKSPACE",
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
				}
				-- print(vim.fn.exepath("python"))
				local site_packages_path = ""
				-- local python_install_path = ""
				-- if vim.fn.has("win32") == 1 then
				-- 	python_install_path = vim.fn.exepath("python")
				-- 	local python_directory = python_install_path:match("(.*)\\[^\\]*$")
				-- 	site_packages_path = python_directory .. "\\lib\\site-packages"
				-- else
				-- 	python_install_path = vim.fn.exepath("python3")
				-- end

				lspconfig[server_namepy].setup({
					filetypes = { "python", ".py" },
					capabilities = capabilities,
					-- cmd = { server_name .. "-langserver", "--stdio" },
					root_dir = function(fname)
						table.unpack = table.unpack or unpack -- 5.1 compatibility
						return util.root_pattern(table.unpack(python_root_files))(fname)
							or util.find_git_ancestor(fname)
							or util.path.dirname(fname)
					end,
					settings = {
						[server_namepy] = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								extraPaths = { site_packages_path },
								useLibraryCodeForTypes = true,
								diagnosticSeverityOverrides = {
									["reportOptionalSubscript"] = "none",
									["reportOperatorIssue"] = "none",
									["reportOptionalIterable"] = "none",
									["reportArgumentType"] = "none",
									["reportIndexIssue"] = "none",
									["reportGeneralTypeIssues"] = "none",
									["reportAssignmentType"] = "none",
									["reportOptionalOperand"] = "none",
									["reportAttributeAccessIssue"] = "none",
									["reportOptionalMemberAccess"] = "none",
									["reportCallIssue"] = "none",
									["reportUnusedImport"] = "none",
									["reportUnusedParameter"] = "none",
									["reportUnusedVariable"] = "none",
									["reportPrivateImportUsage"] = "none",
								},
							},
						},
						python = {
							analysis = {
								diagnosticSeverityOverrides = {
									["reportOptionalSubscript"] = "none",
									["reportOperatorIssue"] = "none",
									["reportOptionalIterable"] = "none",
									["reportArgumentType"] = "none",
									["reportIndexIssue"] = "none",
									["reportGeneralTypeIssues"] = "none",
									["reportAssignmentType"] = "none",
									["reportOptionalOperand"] = "none",
									["reportAttributeAccessIssue"] = "none",
									["reportOptionalMemberAccess"] = "none",
									["reportCallIssue"] = "none",
									["reportUnusedImport"] = "none",
									["reportUnusedParameter"] = "none",
									["reportUnusedVariable"] = "none",
									["reportPrivateImportUsage"] = "none",
								},
							},
						},
					},
				})
			end,

			["jdtls"] = function()
				lspconfig["jdtls"].setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json", "pom.xml") or vim.fn.getcwd(),
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["templ"] = function()
				lspconfig["templ"].setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("go.mod", ".git"), -- Templ uses Go project roots
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["vtsls"] = function()
				lspconfig["vtsls"].setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["kotlin_language_server"] = function()
				lspconfig["kotlin_language_server"].setup({
					filetypes = {
						"kotlin",
						"kt",
					},
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json", ".git") or vim.fn.getcwd(),
					cmd = { "kotlin-language-server.cmd" },
				})
			end,

			["clangd"] = function()
				lspconfig["clangd"].setup({
					filetypes = {
						"c",
						"cpp",
						"objc",
						"objcpp",
					},
					capabilities = capabilities,
					root_dir = util.root_pattern(
						"package.json",
						".clangd",
						"compile_flags.txt",
						"compile_commands.json",
						".vim/",
						".git",
						".hg"
					) or vim.fn.getcwd(),
					settings = {
						clangd = {
							diagnostics = {
								severityOverrides = {
									["*"] = "ignore",
								},
							},
						},
					},
				})
			end,

			["tailwindcss"] = function()
				lspconfig["tailwindcss"].setup({
					filetypes = {
						"css",
						"typescriptreact",
						"typescript",
						"javascriptreact",
						"templ",
						"sass",
						"scss",
						"less",
						"liquid",
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
					settings = {
						gopls = {
							analyses = {
								modernize = false,
								unusedparams = false,
								unusedwrite = false,
								errcheck = false,
								unusedfunc = false,
								unused = false,
							},
						},
					},
				})
			end,

			-- ["phpactor"] = function()
			-- 	lspconfig["phpactor"].setup({
			-- 		filetypes = { "php" },
			-- 		root_dir = function(pattern)
			-- 			local cwd = vim.loop.cwd()
			-- 			local root =
			-- 				util.root_pattern("composer.json", ".git", ".phpactor.json", ".phpactor.yml")(pattern)
			--
			-- 			-- prefer cwd if root is a descendant
			-- 			return util.path.is_descendant(cwd, root) and cwd or root
			-- 		end,
			-- 	})
			-- end,

			["intelephense"] = function()
				lspconfig["intelephense"].setup({
					-- capabilities = capabilities,
					cmd = { "intelephense", "--stdio" },
					filetypes = { "php" },
					root_dir = function(pattern)
						local cwd = vim.fn.getcwd()
						local root = util.root_pattern("composer.json", ".git")(pattern)
						return util.path.is_descendant(cwd, root) and cwd or root
					end,
					settings = {
						intelephense = {
							diagnostics = {
								-- undefinedProperties = false,
								unusedSymbols = false,
								undefinedSymbols = false,
								undefinedMethods = false,
								undefinedProperties = false,
								undefinedTypes = false,
							},
							telemetry = {
								enabled = false,
							},
							completion = {
								fullyQualifyGlobalConstantsAndFunctions = false,
							},
							phpdoc = {
								returnVoid = false,
							},
						},
					},
				})
			end,

			-- ["roslyn"] = function()
			-- 	-- require("roslyn").setup({
			-- 	lspconfig["intelephense"].setup({
			-- 		config = {
			-- 			settings = {
			-- 				["csharp|background_analysis"] = {
			-- 					dotnet_compiler_diagnostics_scope = "fullSolution",
			-- 				},
			-- 				["csharp|inlay_hints"] = {
			-- 					csharp_enable_inlay_hints_for_implicit_object_creation = true,
			-- 					csharp_enable_inlay_hints_for_implicit_variable_types = true,
			-- 					csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			-- 					csharp_enable_inlay_hints_for_types = true,
			-- 					dotnet_enable_inlay_hints_for_indexer_parameters = true,
			-- 					dotnet_enable_inlay_hints_for_literal_parameters = true,
			-- 					dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			-- 					dotnet_enable_inlay_hints_for_other_parameters = true,
			-- 					dotnet_enable_inlay_hints_for_parameters = true,
			-- 					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
			-- 					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
			-- 					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
			-- 				},
			-- 				["csharp|code_lens"] = {
			-- 					dotnet_enable_references_code_lens = true,
			-- 				},
			-- 			},
			-- 		},
			-- 		-- exe = {
			-- 		-- 	"dotnet",
			-- 		-- 	vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
			-- 		-- },
			-- 		args = {
			-- 			"--logLevel=Debug",
			-- 			-- "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			-- 			"--extensionLogDirectory=C:/Users/DELL/.log",
			-- 		},
			-- 		-- filewatching = true,
			-- 	})
			-- end,

			-- ["csharp"] = function()
			-- 	lspconfig["csharp"].setup({
			-- 		filetypes = { "cs" },
			-- 		capabilities = capabilities,
			-- 	})
			-- end,

			["omnisharp"] = function()
				local lsp_server_omnisharp = vim.fn.expand("$HOME/.config/omnisharp/omnisharp.exe")
				local pid = vim.fn.getpid()
				lspconfig["omnisharp"].setup({
					filetypes = {
						"cs",
						"csharp",
						"c_sharp",
					},
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json")
						or ".git"
						or util.root_pattern("csproj")
						or util.root_pattern("sln")
						or vim.fn.getcwd(),
					autoformat = false,
					cmd = { lsp_server_omnisharp, "--languageserver", "--hostPID", tostring(pid) },
					-- cmd = {
					-- 	lsp_server_omnisharp,
					-- 	-- "-z",
					-- 	-- "--hostPID",
					-- 	-- tostring(pid),
					-- 	-- "DotNet:enablePackageRestore=false",
					-- 	-- "--encoding",
					-- 	-- "utf-8",
					-- 	-- "--languageserver",
					-- 	-- "Sdk:IncludePrereleases=true",
					-- 	-- "FormattingOptions:EnableEditorConfigSupport=true",
					-- },
				})
			end,

			-- ["csharp_ls"] = function()
			--   lspconfig["csharp_ls"].setup({
			--     filetypes = {
			--       "cs",
			--       "csharp",
			--       "c_sharp",
			--     },
			--     capabilities = capabilities,
			--     root_dir = util.root_pattern("package.json")
			--       or ".git"
			--       or util.root_pattern("csproj")
			--       or util.root_pattern("sln")
			--       or vim.fn.getcwd(),
			--     autoformat = false,
			--     -- cmd = {  "C:/Users/DELL/.dotnet/tools/csharp-ls.exe" },
			--   })
			-- end,

			["html"] = function()
				lspconfig["html"].setup({
					filetypes = {
						"html",
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
			["theme_check"] = function()
				lspconfig["theme_check"].setup({
					capabilities = capabilities,
					cmd = { "theme-check-liquid-server" },
				})
			end,

			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					filetypes = {
						"html",
						"typescriptreact",
						"typescript",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
						"liquid",
					},
				})
			end,

			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					-- capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
								disable = { "missing-fields" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = {
									vim.env.VIMRUNTIME,
									vim.api.nvim_get_runtime_file("", true),
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
									vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
									vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
									"${3rd}/luv/library",
								},
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
							-- completion = {
							-- 	callSnippet = "Replace",
							-- },
						},
					},
				})
			end,
		})

		-- On Termux, Mason cannot install lua-language-server. Configure it directly
		if is_termux then
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
			})
		end
	end,
}

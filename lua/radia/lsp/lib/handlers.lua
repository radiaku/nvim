-- Mason LSP handlers for each language server
local settings = require("radia.lsp.lib.settings")
local utils = require("radia.lsp.lib.utils")

local M = {}

function M.setup(lspconfig, capabilities, util)
	local server_namepy = "basedpyright"

	return {
		-- Default handler for all servers
		function(server_name)
			lspconfig[server_name].setup({
				capabilities = capabilities,
			})
		end,

		-- Lua Language Server
		["lua_ls"] = function()
			local lua_ls_bin = utils.exepath("lua-language-server")
			if not lua_ls_bin then
				if utils.is_termux() then
					vim.notify("[LSP] 'lua-language-server' not found. On Termux, install from source or skip.", vim.log.levels.WARN)
				end
				return
			end
			lspconfig["lua_ls"].setup({
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
						workspace = {
							library = {
								vim.api.nvim_get_runtime_file("", true),
								vim.env.VIMRUNTIME,
								vim.fn.expand("$VIMRUNTIME/lua"),
								vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
								vim.fn.stdpath("config") .. "/lua",
								vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
								vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
								"${3rd}/luv/library",
							},
						},
						telemetry = { enable = false },
					},
				},
			})
		end,

		-- JSON
		["jsonls"] = function()
			local cmd = utils.exepath("vscode-json-language-server")
			if not cmd then
				return
			end
			lspconfig["jsonls"].setup({
				capabilities = capabilities,
				cmd = { cmd, "--stdio" },
			})
		end,

		-- Python (basedpyright)
		[server_namepy] = function()
			local python_root_files = {
				"WORKSPACE", "pyproject.toml", "setup.py",
				"setup.cfg", "requirements.txt", "Pipfile",
			}
			local site_packages_path = ""
			if vim.fn.has("win32") == 1 then
				local python_install_path = vim.fn.exepath("python")
				local python_directory = python_install_path:match("(.*)\\[^\\]*$")
				site_packages_path = python_directory .. "\\lib\\site-packages"
			end

			local cmd = utils.exepath("basedpyright-langserver") or utils.exepath("pyright-langserver")
			if not cmd then
				if utils.is_termux() then
					vim.notify("[LSP] Python LS not found. Install: npm i -g basedpyright", vim.log.levels.WARN)
				end
				return
			end

			lspconfig[server_namepy].setup({
				filetypes = { "python", ".py" },
				capabilities = capabilities,
				cmd = { cmd, "--stdio" },
				root_dir = function(fname)
					table.unpack = table.unpack or unpack
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
							diagnosticSeverityOverrides = settings.python_diagnostic_overrides,
						},
					},
					python = {
						analysis = {
							diagnosticSeverityOverrides = settings.python_diagnostic_overrides,
						},
					},
				},
			})
		end,

		-- Go
		["gopls"] = function()
			if not utils.ensure("gopls", "Install: pkg install gopls or 'go install golang.org/x/tools/gopls@latest'") then
				return
			end
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

		-- TypeScript/JavaScript
		["vtsls"] = function()
			local cmd = utils.ensure("vtsls", "Install: npm i -g vtsls typescript")
			if not cmd then return end
			lspconfig["vtsls"].setup({
				cmd = { cmd, "--stdio" },
				capabilities = capabilities,
				root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git") or vim.fn.getcwd(),
			})
		end,

		-- HTML
		["html"] = function()
			local cmd = utils.ensure("vscode-html-language-server", "Install: npm i -g vscode-langservers-extracted")
			if not cmd then
				return
			end
			lspconfig["html"].setup({
				cmd = { cmd, "--stdio" },
				filetypes = { "html" },
				capabilities = capabilities,
				init_options = {
					embeddedLanguages = { css = true, javascript = true },
					provideFormatter = true,
				},
				root_dir = util.root_pattern("package.json", ".git") or vim.fn.getcwd(),
				autoformat = false,
			})
		end,

		-- TailwindCSS
		["tailwindcss"] = function()
			local cmd = utils.ensure("tailwindcss-language-server", "Install: npm i -g @tailwindcss/language-server")
			if not cmd then
				return
			end
			lspconfig["tailwindcss"].setup({
				cmd = { cmd, "--stdio" },
				filetypes = {
					"css", "typescriptreact", "typescript", "javascriptreact",
					"templ", "sass", "scss", "less", "liquid", "svelte",
				},
				capabilities = capabilities,
				root_dir = util.root_pattern("tailwind.config.js", "tailwind.config.ts", "postcss.config.js", "postcss.config.ts", "package.json", ".git") or vim.fn.getcwd(),
				autoformat = false,
			})
		end,

		-- PHP
		["intelephense"] = function()
			if not utils.ensure("intelephense", "Install: npm i -g intelephense") then
				return
			end
			lspconfig["intelephense"].setup({
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
							unusedSymbols = false,
							undefinedSymbols = false,
							undefinedMethods = false,
							undefinedProperties = false,
							undefinedTypes = false,
						},
						telemetry = { enabled = false },
						completion = { fullyQualifyGlobalConstantsAndFunctions = false },
						phpdoc = { returnVoid = false },
					},
				},
			})
		end,

		-- Kotlin
		["kotlin_language_server"] = function()
			local bin = vim.fn.has("win32") == 1 and "kotlin-language-server.cmd" or "kotlin-language-server"
			if not utils.ensure(bin, "Install: scoop/choco on Windows, or your package manager on Unix") then
				return
			end
			lspconfig["kotlin_language_server"].setup({
				filetypes = { "kotlin", "kt" },
				capabilities = capabilities,
				root_dir = util.root_pattern("package.json", ".git") or vim.fn.getcwd(),
				cmd = { bin },
			})
		end,

		-- C/C++
		["clangd"] = function()
			if not utils.ensure("clangd", "Install: pkg install clangd") then
				return
			end
			lspconfig["clangd"].setup({
				filetypes = { "c", "cpp", "objc", "objcpp" },
				capabilities = capabilities,
				root_dir = util.root_pattern(
					"package.json", ".clangd", "compile_flags.txt",
					"compile_commands.json", ".vim/", ".git", ".hg"
				) or vim.fn.getcwd(),
				settings = {
					clangd = {
						diagnostics = {
							severityOverrides = { ["*"] = "ignore" },
						},
					},
				},
			})
		end,

		-- Templ
		["templ"] = function()
			lspconfig["templ"].setup({
				capabilities = capabilities,
				root_dir = util.root_pattern("go.mod", ".git"),
			})
		end,

		-- C#
		["omnisharp"] = function()
			local lsp_server_omnisharp = vim.fn.expand("$HOME/.config/omnisharp/omnisharp.exe")
			local pid = vim.fn.getpid()
			lspconfig["omnisharp"].setup({
				filetypes = { "cs", "csharp", "c_sharp" },
				capabilities = capabilities,
				root_dir = util.root_pattern("package.json")
					or ".git"
					or util.root_pattern("csproj")
					or util.root_pattern("sln")
					or vim.fn.getcwd(),
				autoformat = false,
				cmd = { lsp_server_omnisharp, "--languageserver", "--hostPID", tostring(pid) },
			})
		end,

		-- Liquid (Shopify)
		["theme_check"] = function()
			lspconfig["theme_check"].setup({
				capabilities = capabilities,
				cmd = { "theme-check-liquid-server" },
			})
		end,

		-- Emmet
		["emmet_ls"] = function()
			local cmd = utils.exepath("emmet-ls")
			if not cmd then
				return
			end
			lspconfig["emmet_ls"].setup({
				cmd = { cmd, "--stdio" },
				filetypes = {
					"html", "typescriptreact", "typescript", "javascriptreact",
					"css", "sass", "scss", "less", "svelte", "liquid",
				},
			})
		end,

		["emmet_language_server"] = function()
			local cmd = utils.exepath("emmet-language-server")
			if not cmd then
				return
			end
			lspconfig["emmet_language_server"].setup({
				cmd = { cmd, "--stdio" },
				filetypes = {
					"html", "typescriptreact", "typescript", "javascriptreact",
					"css", "sass", "scss", "less", "svelte", "liquid",
				},
			})
		end,
	}
end

return M

local settings = require("radia.lsp.lib.settings")
local utils = require("radia.lsp.lib.utils")

local M = {}

function M.setup(capabilities, util)
	local server_namepy = "basedpyright"

	-- Lua Language Server
	local lua_ls_bin = utils.exepath("lua-language-server")
	if lua_ls_bin then
		vim.lsp.config("lua_ls", {
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
		vim.lsp.enable("lua_ls")
	end

	-- Python (basedpyright)
	local py_bin = utils.exepath("basedpyright-langserver") or utils.exepath("pyright-langserver")
	if py_bin then
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

		vim.lsp.config(server_namepy, {
			filetypes = { "python", ".py" },
			capabilities = capabilities,
			cmd = { py_bin, "--stdio" },
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
		vim.lsp.enable(server_namepy)
	end

	-- Go
	if utils.ensure("gopls", "Install: pkg install gopls or 'go install golang.org/x/tools/gopls@latest'") then
		vim.lsp.config("gopls", {
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
		vim.lsp.enable("gopls")
	end

	-- TypeScript/JavaScript
	if utils.ensure("vtsls", "Install: npm i -g vtsls typescript") then
		vim.lsp.config("vtsls", {
			capabilities = capabilities,
			root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
		})
		vim.lsp.enable("vtsls")
	end

	-- HTML
	if utils.ensure("vscode-html-language-server", "Install: npm i -g vscode-langservers-extracted") then
		vim.lsp.config("html", {
			filetypes = { "html" },
			capabilities = capabilities,
			init_options = {
				embeddedLanguages = { css = true, javascript = true },
				provideFormatter = true,
			},
			root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
		})
		vim.lsp.enable("html")
	end

	-- TailwindCSS
	if utils.ensure("tailwindcss-language-server", "Install: npm i -g @tailwindcss/language-server") then
		vim.lsp.config("tailwindcss", {
			filetypes = {
				"css", "typescriptreact", "typescript", "javascriptreact",
				"templ", "sass", "scss", "less", "liquid", "svelte",
			},
			capabilities = capabilities,
			root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
		})
		vim.lsp.enable("tailwindcss")
	end

	-- PHP
	if utils.ensure("intelephense", "Install: npm i -g intelephense") then
		vim.lsp.config("intelephense", {
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
		vim.lsp.enable("intelephense")
	end

	-- Kotlin
	local kotlin_bin = vim.fn.has("win32") == 1 and "kotlin-language-server.cmd" or "kotlin-language-server"
	if utils.ensure(kotlin_bin, "Install: scoop/choco on Windows, or your package manager on Unix") then
		vim.lsp.config("kotlin_language_server", {
			filetypes = { "kotlin", "kt" },
			capabilities = capabilities,
			root_dir = util.root_pattern("package.json", ".git") or vim.fn.getcwd(),
			cmd = { kotlin_bin },
		})
		vim.lsp.enable("kotlin_language_server")
	end

	-- C/C++
	if utils.ensure("clangd", "Install: pkg install clangd") then
		vim.lsp.config("clangd", {
			filetypes = { "c", "cpp", "objc", "objcpp" },
			capabilities = capabilities,
			root_dir = util.root_pattern(
				"package.json", ".clangd", "compile_flags.txt",
				"compile_commands.json", ".vim/", ".git", ".hg"
			) or vim.fn.getcwd(),
		})
		vim.lsp.enable("clangd")
	end

	-- Templ
	vim.lsp.config("templ", {
		capabilities = capabilities,
		root_dir = util.root_pattern("go.mod", ".git"),
	})
	vim.lsp.enable("templ")

	-- C#
	local omnisharp_path = vim.fn.expand("$HOME/.config/omnisharp/omnisharp.exe")
	if vim.fn.executable(omnisharp_path) == 1 then
		local pid = vim.fn.getpid()
		vim.lsp.config("omnisharp", {
			filetypes = { "cs", "csharp", "c_sharp" },
			capabilities = capabilities,
			root_dir = util.root_pattern("package.json")
				or util.root_pattern(".git")
				or util.root_pattern("csproj")
				or util.root_pattern("sln")
				or vim.fn.getcwd(),
			cmd = { omnisharp_path, "--languageserver", "--hostPID", tostring(pid) },
		})
		vim.lsp.enable("omnisharp")
	end

	-- Liquid (Shopify)
	vim.lsp.config("theme_check", {
		capabilities = capabilities,
		cmd = { "theme-check-liquid-server" },
	})
	vim.lsp.enable("theme_check")

	-- Emmet
	vim.lsp.config("emmet_ls", {
		filetypes = {
			"html", "typescriptreact", "typescript", "javascriptreact",
			"css", "sass", "scss", "less", "svelte", "liquid",
		},
	})
	vim.lsp.enable("emmet_ls")
end

return M

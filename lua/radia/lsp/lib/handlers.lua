local settings = require("radia.lsp.lib.settings")
local utils = require("radia.lsp.lib.utils")

local M = {}

local function setup_server(name, opts)
	local ok, lspconfig = pcall(require, "lspconfig")
	if not ok or not lspconfig[name] then
		return
	end
	lspconfig[name].setup(opts or {})
end

function M.setup(capabilities, util)
	local server_namepy = "basedpyright"

	local lua_ls_bin = utils.exepath("lua-language-server")
	if lua_ls_bin then
		setup_server("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = { "vim" },
						disable = { "missing-fields" },
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							vim.fn.expand("$VIMRUNTIME/lua"),
							vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
							vim.fn.stdpath("config") .. "/lua",
							vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
							"${3rd}/luv/library",
						},
					},
					telemetry = { enable = false },
				},
			},
		})
	end

	local py_bin = utils.exepath("basedpyright-langserver") or utils.exepath("pyright-langserver")
	if py_bin then
		local python_root_files = {
			"WORKSPACE",
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
		}
		local site_packages_path = ""
		if vim.fn.has("win32") == 1 then
			local python_install_path = vim.fn.exepath("python")
			local python_directory = python_install_path:match("(.*)\\[^\\]*$")
			if python_directory then
				site_packages_path = python_directory .. "\\lib\\site-packages"
			end
		end

		setup_server(server_namepy, {
			filetypes = { "python" },
			capabilities = capabilities,
			cmd = { py_bin, "--stdio" },
			root_dir = function(fname)
				table.unpack = table.unpack or unpack
				return util.root_pattern(table.unpack(python_root_files))(fname)
					or util.path.dirname(fname)
			end,
			settings = {
				[server_namepy] = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						extraPaths = site_packages_path ~= "" and { site_packages_path } or {},
						useLibraryCodeForTypes = true,
						exclude = {
							"**/node_modules",
							"**/__pycache__",
							"**/.venv",
							"**/venv",
							"**/dist",
							"**/build",
							"**/.git",
						},
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
	end

	if utils.ensure("gopls", "Install: pkg install gopls or 'go install golang.org/x/tools/gopls@latest'") then
		setup_server("gopls", {
			capabilities = capabilities,
			filetypes = { "go" },
			root_dir = util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					directoryFilters = {
						"-node_modules",
						"-vendor",
						"-.git",
						"-dist",
						"-build",
						"-.cache",
					},
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
	end

	if utils.ensure("vtsls", "Install: npm i -g vtsls typescript") then
		setup_server("vtsls", {
			capabilities = capabilities,
			root_dir = function(fname)
				return util.root_pattern("tsconfig.json", "jsconfig.json", "package.json")(fname)
					or util.find_git_ancestor(fname)
			end,
			settings = {
				vtsls = {
					autoUseWorkspaceTsdk = true,
				},
				typescript = {
					tsserver = {
						maxTsServerMemory = 3072,
					},
				},
			},
		})
	end

	if utils.ensure("vscode-html-language-server", "Install: npm i -g vscode-langservers-extracted") then
		setup_server("html", {
			filetypes = { "html" },
			capabilities = capabilities,
			init_options = {
				embeddedLanguages = { css = true, javascript = true },
				provideFormatter = true,
			},
			root_dir = function(fname)
				return util.root_pattern("package.json")(fname) or util.find_git_ancestor(fname) or vim.fn.getcwd()
			end,
		})
	end

	if utils.ensure("tailwindcss-language-server", "Install: npm i -g @tailwindcss/language-server") then
		setup_server("tailwindcss", {
			filetypes = {
				"css",
				"typescriptreact",
				"javascriptreact",
				"templ",
				"sass",
				"scss",
				"less",
				"liquid",
				"svelte",
			},
			capabilities = capabilities,
			root_dir = function(fname)
				return util.root_pattern(
					"tailwind.config.js",
					"tailwind.config.ts",
					"tailwind.config.cjs",
					"postcss.config.js",
					"postcss.config.ts"
				)(fname)
			end,
		})
	end

	if utils.ensure("intelephense", "Install: npm i -g intelephense") then
		setup_server("intelephense", {
			cmd = { "intelephense", "--stdio" },
			filetypes = { "php" },
			capabilities = capabilities,
			root_dir = function(pattern)
				local cwd = vim.fn.getcwd()
				local root = util.root_pattern("composer.json", ".git")(pattern)
				if root and util.path.is_descendant(cwd, root) then
					return cwd
				end
				return root
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
	end

	local kotlin_bin = vim.fn.has("win32") == 1 and "kotlin-language-server.cmd" or "kotlin-language-server"
	if utils.ensure(kotlin_bin, "Install: scoop/choco on Windows, or your package manager on Unix") then
		setup_server("kotlin_language_server", {
			filetypes = { "kotlin", "kt" },
			capabilities = capabilities,
			cmd = { kotlin_bin },
			root_dir = function(fname)
				return util.root_pattern("package.json", ".git")(fname) or vim.fn.getcwd()
			end,
		})
	end

	if utils.ensure("clangd", "Install: pkg install clangd") then
		setup_server("clangd", {
			filetypes = { "c", "cpp", "objc", "objcpp" },
			capabilities = capabilities,
			root_dir = function(fname)
				return util.root_pattern(
					"package.json",
					".clangd",
					"compile_flags.txt",
					"compile_commands.json",
					".vim/",
					".git",
					".hg"
				)(fname) or vim.fn.getcwd()
			end,
		})
	end

	setup_server("templ", {
		capabilities = capabilities,
		root_dir = util.root_pattern("go.mod", ".git"),
	})

	local omnisharp_path = vim.fn.expand("$HOME/.config/omnisharp/omnisharp.exe")
	if vim.fn.executable(omnisharp_path) == 1 then
		local pid = vim.fn.getpid()
		setup_server("omnisharp", {
			filetypes = { "cs", "csharp", "c_sharp" },
			capabilities = capabilities,
			cmd = { omnisharp_path, "--languageserver", "--hostPID", tostring(pid) },
			root_dir = function(fname)
				return util.root_pattern("*.sln", "*.csproj", ".git", "package.json")(fname) or vim.fn.getcwd()
			end,
		})
	end

	if utils.exepath("theme-check-liquid-server") then
		setup_server("theme_check", {
			capabilities = capabilities,
			cmd = { "theme-check-liquid-server" },
		})
	end

	setup_server("emmet_ls", {
		capabilities = capabilities,
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
end

return M

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

		local function exepath(bin)
			local p = vim.fn.exepath(bin)
			return p ~= "" and p or nil
		end

		local function ensure(bin, hint)
			local p = exepath(bin)
			if not p then
				vim.notify(string.format("[LSP] '%s' not found on PATH. %s", bin, hint or ""), vim.log.levels.WARN)
				return nil
			end
			return p
		end

		local util = require("lspconfig.util") -- NOT "lspconfig/util"

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

		pcall(function()
			require("neodev").setup({})
		end)

		-- Diagnostic signs: modern setup and guard to avoid duplicate defines
		local function setup_diagnostic_signs()
			if vim.g.__radia_signs_defined then
				return
			end
			local sev = vim.diagnostic.severity
			local sign_text = {
				[sev.ERROR] = " ",
				[sev.WARN] = " ",
				[sev.INFO] = " ",
				[sev.HINT] = "󰠠 ",
			}
			-- Prefer Neovim 0.9+/0.10 API to configure signs
			pcall(function()
				vim.diagnostic.config({
					signs = { text = sign_text },
				})
			end)

			-- Avoid manual :sign-define to prevent noisy messages; rely on vim.diagnostic.config
			vim.g.__radia_signs_defined = true
		end
		setup_diagnostic_signs()

		-- Ensure project node bin is on PATH so nvim can see global/local binaries
		do
			local project_bin = vim.fn.getcwd() .. "/node_modules/.bin"
			if vim.fn.isdirectory(project_bin) == 1 then
				local path = vim.env.PATH or ""
				if not path:find(vim.pesc(project_bin), 1, true) then
					vim.env.PATH = project_bin .. ":" .. path
				end
			end
		end

		-- Optional: best-effort venv site-packages discovery for extraPaths
		local function find_site_packages(start_dir)
			local root = util.find_git_ancestor(start_dir) or start_dir
			local candidates = {
				root .. "/.venv/lib/python*/site-packages",
				root .. "/venv/lib/python*/site-packages",
				root .. "/env/lib/python*/site-packages",
			}
			-- expand the glob with vim.fn.glob; return first existing
			for _, pat in ipairs(candidates) do
				local match = vim.fn.glob(pat, true, true) -- list
				if match and #match > 0 then
					return match[1]
				end
			end
		end

		local server_namepy = "basedpyright"

		mason_lspconfig.setup_handlers({
			function(server_name)
				-- https://github.com/neovim/nvim-lspconfig/pull/3232
				-- server_name = server_name == "tsserver" and "ts_ls" or server_name
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["lua_ls"] = function()
				-- configure lua server (with special settings)
				-- On Termux, Mason's lua_ls is not supported; skip if binary missing
				local lua_ls_bin = exepath("lua-language-server")
				if not lua_ls_bin then
					vim.notify("[LSP] 'lua-language-server' not found. On Termux, install from source or skip.",
						vim.log.levels.WARN)
					return
				end
				lspconfig["lua_ls"].setup({
					-- capabilities = capabilities,
					settings = {
						Lua = {

							runtime = { version = "LuaJIT" },
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
								disable = { "missing-fields" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = {
									vim.api.nvim_get_runtime_file("", true),
									vim.env.VIMRUNTIME,
									vim.api.nvim_get_runtime_file("", true),
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
									vim.fn.stdpath("config") .. "/lua",
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

				-- Prefer npm-based server on Termux/Linux/macOS
				local cmd = exepath("basedpyright-langserver") or exepath("pyright-langserver")
				if not cmd then
					vim.notify("[LSP] Python LS not found. Install: npm i -g basedpyright", vim.log.levels.WARN)
					return
				end

				lspconfig[server_namepy].setup({
					filetypes = { "python", ".py" },
					capabilities = capabilities,
					cmd = { cmd, "--stdio" },
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

			-- jdtls removed entirely

			["templ"] = function()
				lspconfig["templ"].setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("go.mod", ".git"), -- Templ uses Go project roots
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["vtsls"] = function()
				local vtsls_bin = ensure("vtsls", "Install: npm i -g vtsls typescript")
				if not vtsls_bin then return end
				lspconfig["vtsls"].setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					-- cmd = { bin_path .. "typescript-language-server.cmd" },
				})
			end,

			["kotlin_language_server"] = function()
				local bin = vim.fn.has("win32") == 1 and "kotlin-language-server.cmd" or "kotlin-language-server"
				if not ensure(bin, "Install: scoop/choco on Windows, or your package manager on Unix") then return end
				lspconfig["kotlin_language_server"].setup({
					filetypes = {
						"kotlin",
						"kt",
					},
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json", ".git") or vim.fn.getcwd(),
					cmd = { bin },
				})
			end,

			["clangd"] = function()
				if not ensure("clangd", "Install: pkg install clangd") then return end
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
				if not ensure("tailwindcss-language-server", "Install: npm i -g @tailwindcss/language-server") then return end
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
				if not ensure("gopls", "Install: pkg install gopls or 'go install golang.org/x/tools/gopls@latest'") then return end
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
				if not ensure("intelephense", "Install: npm i -g intelephense") then return end
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
				if not ensure("vscode-html-language-server", "Install: npm i -g vscode-langservers-extracted") then return end
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
		})

		-- Direct setups on Termux or when installed outside Mason
		-- This bypasses Mason's handlers and configures servers if binaries are present.
		do
			-- gopls
			local gopls_bin = ensure("gopls", "Install: pkg install gopls or 'go install golang.org/x/tools/gopls@latest'")
			if gopls_bin then
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
			end

			-- vtsls (TypeScript/JS)
			local vtsls_bin = ensure("vtsls", "Install: npm i -g vtsls typescript")
			if vtsls_bin then
				lspconfig["vtsls"].setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
				})
			end

			-- HTML
			local html_bin = ensure("vscode-html-language-server", "Install: npm i -g vscode-langservers-extracted")
			if html_bin then
				lspconfig["html"].setup({
					filetypes = { "html" },
					capabilities = capabilities,
					init_options = {
						embeddedLanguages = { css = true, javascript = true },
						provideFormatter = true,
					},
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					autoformat = false,
				})
			end

			-- TailwindCSS
			local tw_bin = ensure("tailwindcss-language-server", "Install: npm i -g @tailwindcss/language-server")
			if tw_bin then
				lspconfig["tailwindcss"].setup({
					filetypes = { "css", "typescriptreact", "typescript", "javascriptreact", "templ", "sass", "scss", "less", "liquid", "svelte" },
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
					autoformat = false,
				})
			end

			-- Intelephense (PHP)
			local intele_bin = ensure("intelephense", "Install: npm i -g intelephense")
			if intele_bin then
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
			end

			-- Python (basedpyright)
			local py_bin = exepath("basedpyright-langserver") or exepath("pyright-langserver")
			if py_bin then
				-- Detect Python venv and Termux site-packages to help import resolution
				local function detect_python_venv()
					local cwd = vim.fn.getcwd()
					for _, name in ipairs({ ".venv", "venv", "env" }) do
						local dir = cwd .. "/" .. name
						if vim.fn.isdirectory(dir) == 1 then
							return cwd, name
						end
					end
					return nil, nil
				end

				local function termux_sitepackages()
					local prefix_env = vim.env.PREFIX or ""
					if prefix_env == "" then
						return nil
					end
					local matches = vim.fn.glob(prefix_env .. "/lib/python*/site-packages", false, true)
					if type(matches) == "table" then
						for _, p in ipairs(matches) do
							if vim.fn.isdirectory(p) == 1 then
								return p
							end
						end
					end
					return nil
				end

				local venv_path, venv_name = detect_python_venv()
				local extra_paths = {}
				local sp = termux_sitepackages()
				if sp then table.insert(extra_paths, sp) end
				-- Also use the project venv site-packages discovery helper
				local project_sp = nil
				pcall(function()
					if type(find_site_packages) == "function" then
						project_sp = find_site_packages(vim.fn.getcwd())
					end
				end)
				if project_sp then table.insert(extra_paths, project_sp) end

				-- Deduplicate paths to avoid redundant entries
				local function dedupe_paths(paths)
					local seen, out = {}, {}
					for _, p in ipairs(paths) do
						if p and p ~= "" and seen[p] ~= true then
							seen[p] = true
							table.insert(out, p)
						end
					end
					return out
				end
				extra_paths = dedupe_paths(extra_paths)

				local py_settings = {
					[server_namepy] = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							diagnosticSeverityOverrides = {
								reportUnusedImport = "none",
							},
						},
					},
				}
				if #extra_paths > 0 then
					py_settings[server_namepy].analysis.extraPaths = extra_paths
				end
				if venv_path and venv_name then
					py_settings.python = { venvPath = venv_path, venv = venv_name }
				end

				lspconfig[server_namepy].setup({
					filetypes = { "python", ".py" },
					capabilities = capabilities,
					cmd = { py_bin, "--stdio" },
					root_dir = function(fname)
						table.unpack = table.unpack or unpack
						local python_root_files = { "WORKSPACE", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
							"Pipfile" }
						return util.root_pattern(table.unpack(python_root_files))(fname)
								or util.find_git_ancestor(fname)
								or util.path.dirname(fname)
					end,
					settings = py_settings,
				})
			end

			-- clangd (optional)
			local clangd_bin = exepath("clangd")
			if clangd_bin then
				lspconfig["clangd"].setup({
					filetypes = { "c", "cpp", "objc", "objcpp" },
					capabilities = capabilities,
					root_dir = util.root_pattern("package.json", ".clangd", "compile_flags.txt", "compile_commands.json", ".vim/",
						".git", ".hg") or vim.fn.getcwd(),
					settings = { clangd = { diagnostics = { severityOverrides = { ["*"] = "ignore" } } } },
				})
			end
		end
	end,
}

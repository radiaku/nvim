-- Direct LSP setups for Termux or system-wide installations
-- These bypass Mason and configure servers if binaries are found on PATH
local settings = require("radia.plugins.lsp.settings")
local utils = require("radia.plugins.lsp.utils")

local M = {}

function M.setup(lspconfig, capabilities, util)
	local server_namepy = "basedpyright"

	-- Go
	local gopls_bin = utils.ensure("gopls", "Install: pkg install gopls or 'go install golang.org/x/tools/gopls@latest'")
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

	-- TypeScript/JavaScript
	local vtsls_bin = utils.ensure("vtsls", "Install: npm i -g vtsls typescript")
	if vtsls_bin then
		lspconfig["vtsls"].setup({
			capabilities = capabilities,
			root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
		})
	end

	-- HTML
	local html_bin = utils.ensure("vscode-html-language-server", "Install: npm i -g vscode-langservers-extracted")
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
	local tw_bin = utils.ensure("tailwindcss-language-server", "Install: npm i -g @tailwindcss/language-server")
	if tw_bin then
		lspconfig["tailwindcss"].setup({
			filetypes = {
				"css", "typescriptreact", "typescript", "javascriptreact",
				"templ", "sass", "scss", "less", "liquid", "svelte",
			},
			capabilities = capabilities,
			root_dir = util.root_pattern("package.json") or vim.fn.getcwd(),
			autoformat = false,
		})
	end

	-- PHP
	local intele_bin = utils.ensure("intelephense", "Install: npm i -g intelephense")
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
	local py_bin = utils.exepath("basedpyright-langserver") or utils.exepath("pyright-langserver")
	if py_bin then
		local function detect_python_venv()
			local buf_dir = vim.api.nvim_buf_get_name(0)
			local start_dir = (buf_dir ~= "" and vim.fn.fnamemodify(buf_dir, ":p:h")) or vim.fn.getcwd()
			local venv_dir = settings.resolve_venv(start_dir)
			if not venv_dir then
				return nil, nil
			end
			local parent = vim.fn.fnamemodify(venv_dir, ":h")
			local name = vim.fn.fnamemodify(venv_dir, ":t")
			return parent, name
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
		if sp then
			table.insert(extra_paths, sp)
		end
		local project_sp = settings.find_site_packages(vim.fn.getcwd(), util)
		if project_sp then
			table.insert(extra_paths, project_sp)
		end

		-- Deduplicate paths
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
					diagnosticSeverityOverrides = settings.python_diagnostic_overrides,
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
				local python_root_files = {
					"WORKSPACE", "pyproject.toml", "setup.py",
					"setup.cfg", "requirements.txt", "Pipfile",
				}
				return util.root_pattern(table.unpack(python_root_files))(fname)
					or util.find_git_ancestor(fname)
					or util.path.dirname(fname)
			end,
			settings = py_settings,
		})
	end

	-- Kotlin
	local kotlin_bin = utils.exepath("kotlin-language-server")
	if kotlin_bin then
		local function get_java_major_version()
			if vim.fn.executable("java") ~= 1 then
				return nil
			end
			local out = vim.fn.system({ "java", "-version" })
			local s = tostring(out)
			local major = s:match("(%d+)%.%d+%.%d+")
			if not major then
				local legacy = s:match('version%s+"1%.(%d+)')
				if legacy then
					return tonumber(legacy)
				end
			end
			return major and tonumber(major) or nil
		end

		local function find_jdk17_home()
			if vim.fn.has("mac") == 1 and vim.fn.executable("/usr/libexec/java_home") == 1 then
				local out = vim.fn.system({ "/usr/libexec/java_home", "-v", "17" })
				if vim.v.shell_error == 0 then
					local home = vim.fn.trim(out)
					if home ~= "" and vim.fn.isdirectory(home) == 1 then
						return home
					end
				end
			end
			local candidates = {
				"/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
				"/usr/local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
				"/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home",
				"/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home",
			}
			for _, p in ipairs(candidates) do
				if vim.fn.isdirectory(p) == 1 then
					return p
				end
			end
			return nil
		end

		local java_major = get_java_major_version()
		local cmd_env
		if (not java_major) or (java_major < 11) or (java_major >= 23) then
			local jdk17 = find_jdk17_home()
			if jdk17 then
				cmd_env = { JAVA_HOME = jdk17, PATH = jdk17 .. "/bin:" .. (vim.env.PATH or "") }
			end
		end

		lspconfig["kotlin_language_server"].setup({
			cmd = { kotlin_bin },
			cmd_env = cmd_env,
			capabilities = capabilities,
			root_dir = util.root_pattern("settings.gradle", "build.gradle", "pom.xml", ".git") or vim.fn.getcwd(),
		})
	end

	-- C/C++
	local clangd_bin = utils.exepath("clangd")
	if clangd_bin then
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
	end
end

return M

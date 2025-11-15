return {
	"williamboman/mason.nvim",
	commit = "fc9883",
	dependencies = {
		{ "williamboman/mason-lspconfig.nvim", commit = "8e46de" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "125551" },
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")
		local mason_lspconfig = require("mason-lspconfig")

		-- enable mason and configure icons
		mason.setup({
			PATH = "prepend",
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local has_go = vim.fn.executable("go") == 1
		local has_node = vim.fn.executable("node") == 1
		local has_python = vim.fn.executable("python") == 1 or vim.fn.executable("python3") == 1

		-- Detect Termux (Android) to avoid installing unsupported Mason packages
		local is_termux = false
		local prefix = vim.env.PREFIX or ""
		if prefix:find("com%.termux") then
			is_termux = true
		end

		local servers = {}
		if not is_termux then
			table.insert(servers, "lua_ls")
		end

		local tools = {}
		-- stylua via Mason is unsupported on Termux; prefer cargo install there
		if not is_termux then
			table.insert(tools, "stylua")
		end

		if has_go and not is_termux then
			table.insert(servers, "gopls")
		else
			-- vim.notify("Go not found in PATH: skipping gopls", vim.log.levels.WARN)
		end

		if has_node then
			table.insert(servers, "vtsls")
			table.insert(servers, "cssls")
			table.insert(servers, "html")
			table.insert(servers, "emmet_ls")
			table.insert(servers, "tailwindcss")
			table.insert(servers, "html")
			table.insert(servers, "intelephense")
			table.insert(servers, "jsonls")
			table.insert(tools, "prettier")
			table.insert(tools, "eslint_d")
		else
			-- vim.notify("Node.js not found in PATH: skipping vtsls", vim.log.levels.WARN)
		end

		if has_python then
			-- Prefer basedpyright and never install pyright alongside it
			table.insert(servers, "basedpyright")
			table.insert(tools, "black")
			table.insert(tools, "pylint")
		else
			-- vim.notify("Python not found in PATH: skipping basedpyright", vim.log.levels.WARN)
		end

		-- Check the operating system and append the appropriate Python language server
		-- if vim.fn.has("win32") == 1 then
		-- 	table.insert(ensure_installed, "pyright")
		-- else
		-- 	table.insert(ensure_installed, "basedpyright")
		-- end


		-- Only ensure-install servers/tools that are missing globally
		local function exepath(bin)
			local p = vim.fn.exepath(bin)
			return p ~= "" and p or nil
		end

		local server_bins = {
			gopls = { "gopls" },
			vtsls = { "vtsls" },
			cssls = { "vscode-css-language-server" },
			html = { "vscode-html-language-server" },
			emmet_ls = { "emmet-language-server" },
			tailwindcss = { "tailwindcss-language-server" },
			intelephense = { "intelephense" },
			jsonls = { "vscode-json-language-server" },
			basedpyright = { "basedpyright-langserver", "pyright-langserver" },
			lua_ls = { "lua-language-server" },
		}

		-- Strong guard: ensure 'pyright' is never scheduled for installation
		local sanitized_servers = {}
		for _, name in ipairs(servers) do
			if name ~= "pyright" then
				table.insert(sanitized_servers, name)
			end
		end

		local filtered_servers = {}
		local seen = {}
		for _, name in ipairs(sanitized_servers) do
			if not seen[name] then
				seen[name] = true
				-- On Termux, avoid Mason for lua_ls
				if not (is_termux and name == "lua_ls") then
					local bins = server_bins[name]
					local found = false
					for _, b in ipairs(bins or {}) do
						if exepath(b) then
							found = true
							break
						end
					end
					if not found then
						table.insert(filtered_servers, name)
					end
				end
			end
		end

		local filtered_tools = {}
		for _, t in ipairs(tools) do
			-- stylua via Mason unsupported on Termux
			if not (is_termux and t == "stylua") then
				if not exepath(t) then
					table.insert(filtered_tools, t)
				end
			end
		end

		mason_lspconfig.setup({
			ensure_installed = filtered_servers,
			automatic_installation = not is_termux,
		})

		mason_tool_installer.setup({
			ensure_installed = filtered_tools,
		})
	end,
}

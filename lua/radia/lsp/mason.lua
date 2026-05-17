return {
	"williamboman/mason.nvim",
	dependencies = {
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	},
	config = function()
		local utils = require("radia.utils")
		local ok_mason, mason = pcall(require, "mason")
		local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
		local ok_mason_tool_installer, mason_tool_installer = pcall(require, "mason-tool-installer")

		if not ok_mason or not ok_mason_lspconfig or not ok_mason_tool_installer then
			local errors = {}
			if not ok_mason then
				table.insert(errors, ("mason.nvim: %s"):format(mason))
			end
			if not ok_mason_lspconfig then
				table.insert(errors, ("mason-lspconfig.nvim: %s"):format(mason_lspconfig))
			end
			if not ok_mason_tool_installer then
				table.insert(errors, ("mason-tool-installer.nvim: %s"):format(mason_tool_installer))
			end

			vim.schedule(function()
				vim.notify(
					("[Mason] Disabled because the plugin install is incomplete or incompatible.\n%s"):format(
						table.concat(errors, "\n")
					),
					vim.log.levels.WARN
				)
			end)
			return
		end

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
		local is_termux = utils.is_termux()

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
			-- table.insert(tools, "black")
			-- table.insert(tools, "pylint")
		else
			-- vim.notify("Python not found in PATH: skipping basedpyright", vim.log.levels.WARN)
		end

		-- Only ensure-install servers/tools that are missing globally
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

		-- Consolidate server filtering logic
		local filtered_servers = {}
		local seen = {}
		for _, name in ipairs(servers) do
			-- Skip pyright (never install alongside basedpyright)
			if name ~= "pyright" and not seen[name] then
				seen[name] = true
				-- On Termux, avoid Mason for lua_ls
				if not (is_termux and name == "lua_ls") then
					local bins = server_bins[name]
					local found = false
					for _, b in ipairs(bins or {}) do
						if utils.exepath(b) then
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
				if not utils.exepath(t) then
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

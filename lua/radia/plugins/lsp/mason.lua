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

		if has_go then
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

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = servers,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = not is_termux, -- disable on Termux to avoid failed installs
		})


		mason_tool_installer.setup({
			ensure_installed = tools
		})
	end,
}

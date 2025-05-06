return {
	"williamboman/mason.nvim",
	commit = "fc9883",
	dependencies = {
        {"williamboman/mason-lspconfig.nvim", commit = "8e46de"},
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

		local ensure_installed = {
			"html",
			"cssls",
			"lua_ls",
			"jsonls",
			"gopls",
			-- "tsserver",
			"vtsls",
			"tailwindcss",
			-- "jedi_language_server",
			"basedpyright",
			-- "pylsp",
			"intelephense",
			"emmet_ls",
		}

		-- Check the operating system and append the appropriate Python language server
		-- if vim.fn.has("win32") == 1 then
		-- 	table.insert(ensure_installed, "pyright")
		-- else
		-- 	table.insert(ensure_installed, "basedpyright")
		-- end

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = ensure_installed,
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				-- "isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
			},
		})
	end,
}

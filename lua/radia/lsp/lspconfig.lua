local blink_ok, blink = pcall(require, "blink.cmp")

return {
	"neovim/nvim-lspconfig",
	commit = "62c5fac4c59be9e41b92ef62f3bb0fbdae3e2d9e",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		(not blink_ok) and { "hrsh7th/cmp-nvim-lsp", commit = "a8912b" } or nil,
	},
	config = function()
		-- Load modules
		local utils = require("radia.lsp.lib.utils")
		local settings = require("radia.lsp.lib.settings")
		local handlers = require("radia.lsp.lib.handlers")
		local direct = require("radia.lsp.lib.direct")

		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		-- Setup neodev if available
		pcall(function()
			require("neodev").setup({})
		end)

		-- Get capabilities
		local capabilities = settings.get_capabilities()

		-- Setup diagnostic signs
		utils.setup_diagnostic_signs()

		-- Add project node_modules to PATH
		utils.setup_node_path()

		-- Mason handlers (for desktop/managed installations)
		mason_lspconfig.setup_handlers(handlers.setup(lspconfig, capabilities, util))

		-- Direct setups (for Termux or system-wide installations)
		if utils.is_termux() then
			direct.setup(lspconfig, capabilities, util)
		end
	end,
}

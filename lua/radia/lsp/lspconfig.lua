local blink_ok, blink = pcall(require, "blink.cmp")

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		(not blink_ok) and { "hrsh7th/cmp-nvim-lsp" } or nil,
	},
	config = function()
		-- Load modules
		local utils = require("radia.lsp.lib.utils")
		local settings = require("radia.lsp.lib.settings")
		local handlers = require("radia.lsp.lib.handlers")
		local direct = require("radia.lsp.lib.direct")
		local util = require("lspconfig.util")
		local ok_mason, mason = pcall(require, "mason")
		local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")

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

		-- Define custom server config overrides using the new vim.lsp.config API
		handlers.setup(capabilities, util)

		-- Mason setup (for desktop/managed installations)
		if ok_mason and ok_mason_lspconfig then
			mason_lspconfig.setup({})
		end

		-- Direct setups (for Termux, system-wide installations, or Mason fallback)
		if utils.is_termux() or not (ok_mason and ok_mason_lspconfig) then
			direct.setup(capabilities, util)
		end
	end,
}

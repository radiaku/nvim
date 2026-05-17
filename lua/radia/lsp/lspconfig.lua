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

		local lspconfig = require("lspconfig")
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

		-- Mason handlers (for desktop/managed installations)
		if ok_mason and ok_mason_lspconfig then
			mason_lspconfig.setup_handlers(handlers.setup(lspconfig, capabilities, util))
		else
			vim.schedule(function()
				local details = {}
				if not ok_mason then
					table.insert(details, ("mason.nvim: %s"):format(mason))
				end
				if not ok_mason_lspconfig then
					table.insert(details, ("mason-lspconfig.nvim: %s"):format(mason_lspconfig))
				end
				vim.notify(
					("[LSP] Mason unavailable, falling back to direct server setup.\n%s"):format(
						table.concat(details, "\n")
					),
					vim.log.levels.WARN
				)
			end)
		end

		-- Direct setups (for Termux, system-wide installations, or Mason fallback)
		if utils.is_termux() or not (ok_mason and ok_mason_lspconfig) then
			direct.setup(lspconfig, capabilities, util)
		end
	end,
}

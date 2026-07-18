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
		local guard = require("radia.lsp.lib.guard")

		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")

		-- Mason may still be VeryLazy; only wire handlers when available.
		-- PATH prepend is enough if packages already live under mason/bin.
		pcall(function()
			require("mason").setup({ PATH = "prepend" })
		end)

		-- Skip LSP attach for buffers whose file was deleted outside nvim;
		-- also defers attach for non-focused buffers during bulk open.
		guard.setup()

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

		local specs = handlers.setup(lspconfig, capabilities, util)

		-- Mason handlers (for desktop/managed installations)
		local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
		if ok_mlsp and mason_lspconfig.setup_handlers then
			-- Ensure mason-lspconfig is initialized even if mason plugin is still lazy
			pcall(function()
				mason_lspconfig.setup({ automatic_installation = false })
			end)
			mason_lspconfig.setup_handlers(specs)
		else
			-- Fallback: register common servers directly (PATH / mason bin already installed)
			for name, fn in pairs(specs) do
				if type(name) == "string" and type(fn) == "function" then
					pcall(fn)
				end
			end
		end

		-- Direct setups (for Termux or system-wide installations)
		if utils.is_termux() then
			direct.setup(lspconfig, capabilities, util)
		end
	end,
}

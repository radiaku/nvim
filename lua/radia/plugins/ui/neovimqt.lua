return {
	"equalsraf/neovim-gui-shim",
	lazy = true,
	enabled = vim.g.neovide ~= nil or vim.g.GuiLoaded ~= nil,
}

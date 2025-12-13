local themesname = _G.themesname or "sonokai"

if vim.g.neovide or vim.g.GuiLoaded then
	local ok, theme = pcall(require, themesname)
	if ok and theme.setup then
		theme.setup({
			transparent = false,
		})
	end
end

local ok = pcall(vim.cmd, "colorscheme " .. themesname)
if not ok then
	-- Fallback to default colorscheme if theme not available
	vim.cmd("colorscheme default")
end

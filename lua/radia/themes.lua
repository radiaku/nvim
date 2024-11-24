-- local themesname = "cyberdream"
-- local themesname = "monet"
-- local themesname = "gruvbox-baby"
-- local themesname = "tokyonight"
-- local themesname = "sonokai"
local themesname = _G.themesname
-- local themesname = "github_dark_dimmed"

if vim.g.neovide then
	require(themesname).setup({
		transparent = false,
	})
elseif vim.g.GuiLoadedi then
	require(themesname).setup({
		transparent = false,
	})
else
	-- require(themesname).setup({
	-- 	transparent = true,
	-- 	styles = {
	-- 		sidebars = "transparent",
	-- 		floats = "transparent",
	-- 	},
	-- 	use_background = false,
	-- })
end

-- Apply custom highlights on colorscheme change.
-- Must be declared before executing ':colorscheme'.

-- local grpid = vim.api.nvim_create_augroup("custom_highlights_sonokai", {})
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	group = grpid,
-- 	pattern = "sonokai",
-- 	callback = function()
-- 		local config = vim.fn["sonokai#get_configuration"]()
-- 		local palette = vim.fn["sonokai#get_palette"](config.style, config.colors_override)
-- 		local set_hl = vim.fn["sonokai#highlight"]
--
-- 		set_hl("Visual", palette.none, palette.grey_dim)
-- 		-- set_hl("IncSearch", palette.green, palette.yellow)
-- 		-- set_hl("Search", palette.none, palette.diff_yellow)
-- 	end,
-- })

-- vim.cmd([[colorscheme tokyonight]])
vim.cmd("colorscheme " .. themesname)

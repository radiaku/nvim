-- vim.cmd.colorscheme "catppuccin"
-- colorscheme

-- require("tokyonight").setup({
-- 	transparent = true,
-- 	styles = {
-- 		sidebars = "transparent",
-- 		floats = "transparent",
-- 	},
-- 	use_background = false,
-- })

if vim.g.neovide then
	require("tokyonight").setup({
		transparent = false,
	})
elseif vim.g.GuiLoadedi then
	require("tokyonight").setup({
		transparent = false,
	})
else
	require("tokyonight").setup({
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
		use_background = false,
	})
end

vim.cmd([[colorscheme tokyonight]])

return {
	"scottmckendry/cyberdream.nvim",
	commit = "274eac",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup({
			-- Recommended - see "Configuring" below for more config options
			transparent = true,
			italic_comments = true,
			hide_fillchars = true,
			borderless_telescope = true,
		})
	end,
}

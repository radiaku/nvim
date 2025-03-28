return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		require("bufferline").setup({
			options = {
				offsets = {
					{
						filetype = "neo-tree",
						text = "NeoTree",
						separator = true,
						text_align = "left",
					},
				},
				hover = {
					enabled = true,
					delay = 150,
					reveal = { "close" },
				},
			},
		})

	end,
}

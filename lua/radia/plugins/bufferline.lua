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

		-- Move Between tab buffer
		local keymap = require("vim.keymap")
		keymap.set(
			"n",
			"<S-l>",
			"<CMD>BufferLineCycleNext<CR>",
			{ desc = "Move to left tab buffer", noremap = true, silent = true }
		)
		keymap.set(
			"n",
			"<S-h>",
			"<CMD>BufferLineCyclePrev<CR>",
			{ desc = "Move to right tab buffer", noremap = true, silent = true }
		)

		keymap.set(
			"n",
			"<C-l>",
			"<CMD>BufferLineMoveNext<CR>",
			{ desc = "Move buffer to next left ", noremap = true, silent = true }
		)
		keymap.set(
			"n",
			"<C-h>",
			"<CMD>BufferLineMovePrev<CR>",
			{ desc = "Move buffer to right", noremap = true, silent = true }
		)
	end,
}

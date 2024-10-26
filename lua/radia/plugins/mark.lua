return {
	"chentoast/marks.nvim",
	event = "VeryLazy",

	config = function()
		require("marks").setup({
			mappings = {
				set_next = "mm",
				next = "mn",
				prev = "mp",
				set_bookmark0 = "m0",
				delete_buf = "dm<space>",
				delete_line = "dm-",
				-- delete_bookmark = "dmx",
			},
		})
	end,
}

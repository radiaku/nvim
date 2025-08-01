return {
	"chentoast/marks.nvim",
	event = "VeryLazy",

	config = function()
		require("marks").setup({
			mappings = {
				set = "m>",
				set_next = "mm",
				next = "mn",
				prev = "mp",
				set_bookmark0 = "m0",
				delete_buf = "dmb",
				delete_line = "dml",
				-- delete_bookmark = "dmx",
			},
		})
	end,
}

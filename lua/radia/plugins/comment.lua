return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- import comment plugin safely
		local comment = require("Comment")

		-- enable comment
		comment.setup({
			padding = true,
			sticky = true,
			ignore = nil,
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			mappings = {
				basic = true,
				extra = false,
			},
			pre_hook = nil,
			post_hook = nil,
		})
	end,
}

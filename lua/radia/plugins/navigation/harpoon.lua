return {
	"ThePrimeagen/harpoon",
	-- branch = "harpoon2",
	commit = "ed1f85",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- set keymaps
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({})
		-- REQUIRED
		--
		-- basic telescope configuration
	end,
}

return {
	"folke/trouble.nvim",
	commit = "85bedb",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		require("trouble").setup({ auto_preview = false })
	end,
}

return {
	{
		"mfussenegger/nvim-dap",
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {
			virt_text_win_col = 80,
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()
		end,
	},
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()
		end,
	},
}

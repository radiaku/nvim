return {
	"kdheepak/lazygit.nvim",
	commit = "b9eae3",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").load_extension("lazygit")

		vim.g.lazygit_floating_window_winblend = 0
		vim.g.lazygit_floating_window_scaling_factor = 0.9
		vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
		vim.g.lazygit_floating_window_use_plenary = 1
		vim.g.lazygit_use_neovim_remote = 0

		vim.g.lazygit_use_custom_config_file_path = 0
		vim.g.lazygit_config_file_path = ""
	end,
}

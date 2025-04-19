return {
	"akinsho/toggleterm.nvim",
	commit = "50ea08",
	-- version = "*",
	config = function()
		require("toggleterm").setup()

		-- local toggleterm = require("toggleterm")
		--
		-- toggleterm.setup({
		-- 	size = 10,
		-- 	open_mapping = [[<c-t>]],
		-- 	hide_numbers = true,
		-- 	shade_filetypes = {},
		-- 	shade_terminals = true,
		-- 	shading_factor = 1,
		-- 	start_in_insert = true,
		-- 	insert_mappings = true,
		-- 	persist_size = true,
		-- 	direction = "float",
		-- 	close_on_exit = true,
		-- 	shell = vim.o.shell,
		-- 	float_opts = {
		-- 		border = "single",
		-- 		winblend = 0,
		-- 		highlights = {
		-- 			border = "Normal",
		-- 			background = "Normal",
		-- 		},
		-- 	},
		-- })
		--
		-- local Terminal = require("toggleterm.terminal").Terminal
		-- local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
		--
		-- function LAZYGIT_TOGGLE()
		-- 	lazygit:toggle()
		-- end
		-- vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit" })
	end,
}

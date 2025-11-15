return {
	"mikavilpas/yazi.nvim",
	version = "v10.3.0",
	-- Only enable if the yazi binary is available to avoid errors
	enabled = function()
		local has_yazi = vim.fn.executable("yazi") == 1
		-- yazi.nvim uses vim.ringbuf, which is available in Neovim 0.10+
		local has_ringbuf = (vim.fn.has("nvim-0.10") == 1) or (type(vim.ringbuf) == "function")
		return has_yazi and has_ringbuf
	end,
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			"<leader>yc",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
		{
			-- Open in the current working directory
			"<leader>yw",
			"<cmd>Yazi cwd<cr>",
			desc = "Open the file manager in nvim's working directory",
		},
	},
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
		},
	},
	-- 👇 if you use `open_for_directories=true`, this is recommended
	init = function()
		-- mark netrw as loaded so it's not loaded at all.
		--
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1
	end,
}

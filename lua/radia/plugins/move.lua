return {
	"fedepujol/move.nvim",
	config = function()
		local opts = { noremap = true, silent = true }

		vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
		vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
		vim.keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
		vim.keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)
	end,
}

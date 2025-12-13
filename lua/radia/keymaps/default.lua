vim.cmd([[
  set mouse=a
  cmap <S-Insert>  <C-R>+

  " ON toggleterm or terminal change to normal mode"
  tnoremap <C-\> <C-\><C-N>
  tnoremap <C-t> <C-\><C-N>:ToggleTerm<CR>
  tnoremap <Esc> <C-\><C-N> 
  tnoremap <A-h> <C-\><C-N><C-w>h
  tnoremap <A-j> <C-\><C-N><C-w>j
  tnoremap <A-k> <C-\><C-N><C-w>k
  tnoremap <A-l> <C-\><C-N><C-w>l
]])

local map = require("radia.keymaps.helper").map

-- Insert mode keymaps
map("i", "jk", "<ESC>", "Exit insert mode with jk")
map("i", "<S-Insert>", "<C-R>+", "Paste with shift+insert")
map("i", "<A-P>", "<C-R>+", "Paste with Alt+P on insert mode")

-- Command mode keymaps
map("c", "<C-j>", "<C-n>", "Move down on wildmenu")
map("c", "<C-k>", "<C-p>", "Move up on wildmenu")

-- Normal mode keymaps
map("n", "<leader>nh", ":nohl<CR>", "Clear search highlights")
map("n", "t", "<cmd>HopPattern<CR>", "Hop")

-- Window management
map("n", "<leader>sv", "<C-w>v", "Split window vertically")
map("n", "<leader>sh", "<C-w>s", "Split window horizontally")
map("n", "<leader>sx", "<cmd>close<CR>", "Close current split")

-- Buffer management
map("n", "<leader>bd", "<cmd>bd!<CR>", "Close Buffer (bd)")
map("n", "<leader>ba", ":%bd|e#|bd#<CR>", "Close Buffer All except unsaved (bd)")
map("n", "<leader>co", ":only<CR>", "Close Other Split windows")
map("n", "<leader>bk", ":q!<CR>", "Quit")

-- Database UI
map("n", "<leader>db", ":DBUIToggle<CR>", "TOGGLE DBUI")
map("n", "<leader>dc", ":DBUIAddConnection<CR>", "ADD CONNECTION")

-- Window navigation
map("n", "<A-h>", "<C-w>h", "Move to left windows")
map("n", "<A-l>", "<C-w>l", "Move to right windows")
map("n", "<A-j>", "<C-w>j", "Move to down windows")
map("n", "<A-k>", "<C-w>k", "Move to upper windows")

-- Working directory
map("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", "Changing Working Directory")

-- Window resize
map("n", "<M-,>", "<C-w>5<", "Resize to Left")
map("n", "<M-.>", "<C-w>5>", "Resize to Right")
map("n", "<M-u>", "<C-w>+", "Resize Up")
map("n", "<M-d>", "<C-w>-", "Resize Down")

-- Font reset
map("n", "<M-0>", "<cmd>:GuiFont! JetBrainsMono Nerd Font:h14<CR>", "Reset Font")

-- Save and quickfix
map("n", "<leader>sa", ":wa<CR>", "Save all")
map("n", "<leader>qf", ":copen<CR>", "quick fix")
map("n", "<leader>cc", ":cclose<CR>", "Close QuickFix")

-- LSP keymaps (configured via autocmd for buffer-local mappings)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts_lsp = { buffer = ev.buf, silent = true }

		opts_lsp.desc = "Show LSP type all References"
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts_lsp)

		opts_lsp.desc = "Show LSP definitions"
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts_lsp)

		opts_lsp.desc = "Show LSP implementations"
		vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts_lsp)

		opts_lsp.desc = "See available code actions"
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts_lsp)

		opts_lsp.desc = "Smart rename"
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts_lsp)

		opts_lsp.desc = "Show signature or HINT"
		vim.keymap.set("i", "<M-k>", function() vim.lsp.buf.signature_help() end, opts_lsp)

		opts_lsp.desc = "Show line diagnostics"
		vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts_lsp)

		opts_lsp.desc = "Show documentation for what is under cursor"
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts_lsp)

		opts_lsp.desc = "Restart LSP"
		vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts_lsp)
	end,
})

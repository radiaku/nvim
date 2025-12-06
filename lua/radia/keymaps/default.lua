vim.cmd([[
  set mouse=a
  " source $VIMRUNTIME/mswin.vim
  " imap <S-Insert> <C-R>*
  " noremap y "*y
  " noremap yy "*yy
  " noremap Y "*y$
  "
  " imap <silent>  <C-R>+
  " imap <C-v> <C-R>*
  cmap <S-Insert>  <C-R>+

  " ON toggleterm or terminal change to normal mode"
  tnoremap <C-\> <C-\><C-N>
  tnoremap <C-t> <C-\><C-N>:ToggleTerm<CR>
  tnoremap <Esc> <C-\><C-N> 
  tnoremap <A-h> <C-\><C-N><C-w>h
  tnoremap <A-j> <C-\><C-N><C-w>j
  tnoremap <A-k> <C-\><C-N><C-w>k
  tnoremap <A-l> <C-\><C-N><C-w>l

  " tnoremap <C-S-h> <C-\><C-N><C-w>h
  " tnoremap <C-S-j> <C-\><C-N><C-w>j
  " tnoremap <C-S-k> <C-\><C-N><C-w>k
  " tnoremap <C-S-l> <C-\><C-N><C-w>l

]])

local keymap = vim.keymap -- for conciseness

-- Plugin map
local opts = { noremap = true, silent = true }

-- ctrl+shift+v
-- keymap.set("c", "<M-v>", "<C-R>+", { desc="ctrl+shift+v paste neovim",  opts})

-- use jk to exit insert mode
opts = { desc = "Exit insert mode with jk" }
keymap.set("i", "jk", "<ESC>", opts)

-- Move around commandline cmdline or wildmenu auto complete using jk
opts = { desc = "Move down on wildmenu" }
keymap.set("c", "<C-j>", "<C-n>", opts)
opts = { desc = "Move up on wildmenu" }
keymap.set("c", "<C-k>", "<C-p>", opts)

-- Move around when insertmode using ctrl j + k
-- opts = { desc = "Move down on wildmenu" }
-- keymap.set("i", "<C-j>", "<C-n>", opts)
-- opts = { desc = "Move down on wildmenu" }
-- keymap.set("i", "<C-k>", "<C-p>", opts)
--

-- set shift insert to paste on insert mode
opts = { desc = "Paste with shift+insert" }
keymap.set("i", "<S-Insert>", "<C-R>+", opts)
opts = { desc = "Paste with Alt+P on insert mode" }
keymap.set("i", "<A-P>", "<C-R>+", opts)

-- clear search highlights
opts = { desc = "Clear search highlights" }
keymap.set("n", "<leader>nh", ":nohl<CR>", opts)

-- Hop
opts = { desc = "Hop" }
keymap.set("n", "t", "<cmd>HopPattern<CR>", opts)
-- '<,'>normal 0f{f"yi"Oopts = { desc = "^[pA"^[n}

-- window management
opts = { desc = "Split window vertically" }
keymap.set("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
opts = { desc = "Split window horizontally" }
keymap.set("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
-- opts = { desc = "Make splits equal size"}
-- keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
opts = { desc = "Close current split" }
keymap.set("n", "<leader>sx", "<cmd>close<CR>", opts) -- close current split window

-- destory buffer
opts = { desc = "Close Buffer (bd)" }
keymap.set("n", "<leader>bd", "<cmd>bd!<CR>", opts) --  Close Buffer (bd)
opts = { desc = "Close Buffer All except unsaved (bd)" }
keymap.set("n", "<leader>ba", ":%bd|e#|bd#<CR>", opts) --  Close Buffer (bd)

-- opts = { desc = "Kill all and exit"}
-- keymap.set("n", "<leader>baf", ":qa!", opts)
opts = { desc = "Close Other Split windows" }
keymap.set("n", "<leader>co", ":only<CR>", opts)
opts = { desc = "Quit " }
keymap.set("n", "<leader>bk", ":q!<CR>", opts) --  Close Buffer (bd)

opts = { desc = "TOGGLE DBUI" }
keymap.set("n", "<leader>db", ":DBUIToggle<CR>", opts)
opts = { desc = "ADD CONNECTION" }
keymap.set("n", "<leader>dc", ":DBUIAddConnection<CR>", opts)

-- move between windows, uppside done on mac set to iterm2
-- \<C-w>h on profile
-- opts = { desc = "Move to left windows"}
-- keymap.set("n", "<M-h>", "<C-w>h", opts)
-- opts = { desc = "Move to right windows"}
-- keymap.set("n", "<M-l>", "<C-w>l", opts)
-- opts = { desc = "Move to down windows"}
-- keymap.set("n", "<M-j>", "<C-w>j", opts)
-- opts = { desc = "Move to upper windows"}
-- keymap.set("n", "<M-k>", "<C-w>k", opts)

opts = { desc = "Move to left windows"}
keymap.set("n", "<A-h>", "<C-w>h", opts)
opts = { desc = "Move to right windows"}
keymap.set("n", "<A-l>", "<C-w>l", opts)
opts = { desc = "Move to down windows"}
keymap.set("n", "<A-j>", "<C-w>j", opts)
opts = { desc = "Move to upper windows"}
keymap.set("n", "<A-k>", "<C-w>k", opts)

-- change working directory to the location of the current file
opts = { desc = "Changing Working Directory" }
keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", opts)
-- opts = { desc = "Changing Working Directory"}
-- keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", opts)

-- resize split
opts = { desc = "Resize to Left" }
keymap.set("n", "<M-,>", "<C-w>5<", opts)
opts = { desc = "Resize to Right" }
keymap.set("n", "<M-.>", "<C-w>5>", opts)
opts = { desc = "Resize Up" }
keymap.set("n", "<M-u>", "<C-w>+", opts)
opts = { desc = "Resize Down" }
keymap.set("n", "<M-d>", "<C-w>-", opts)

-- Move between buffers
-- opts = { desc = "Next Buffer"}
-- keymap.set("n", "<S-l>", ":bnext<CR>", opts)
-- opts = { desc = "Previous Buffer"}
-- keymap.set("n", "<S-h>", ":bprevious<CR>",opts)

-- set previous and next opened buffer
-- opts = { desc = "Next Buffer"}
-- keymap.set("n", "<C-n>", ":bnext<CR>", opts)
-- opts = { desc = "Previous Buffer"}
-- keymap.set("n", "<C-p>", ":bprevious<CR>", opts)

-- opts = { desc = "Resize to right"}
-- keymap.set("n", "<M-,>", "<C-w>5<", opts)
-- opts = { desc = "Resize to Left"}
-- keymap.set("n", "<M-.>", "<C-w>5>", opts)
-- opts = { desc = "Resize Up"}
-- keymap.set("n", "<M-u>", "<C-w>+", opts)
-- opts = { desc = "Resize Down"}
-- keymap.set("n", "<M-d>", "<C-w>-", opts)
-- opts = { desc = "Resize F"}
-- keymap.set("n", "<M-f>", "<C-w>=", opts)

-- reset font
opts = { desc = "Reset Font" }
keymap.set("n", "<M-0>", "<cmd>:GuiFont! JetBrainsMono Nerd Font:h14<CR>", opts)

-- save all
opts = { desc = "Save all" }
keymap.set("n", "<leader>sa", ":wa<CR>", opts)

--  :copen
opts = { desc = "quick fix" }
keymap.set("n", "<leader>qf", ":copen<CR>", opts)

opts = { desc = "Close QuickFix" }
keymap.set("n", "<leader>cc", ":cclose<CR>", opts)

-- Lsp
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts_lsp = { buffer = ev.buf, silent = true }

		-- set keybinds
		-- opts_lsp.desc = "Show LSP references"
		-- keymap.set("n", "gR", "<cmd>Telescope lsp_references theme=dropdown<CR>", opts_lsp) -- show definition, references

		opts_lsp.desc = "Show LSP type all References"
		keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts_lsp) -- Show LSP type all References

		-- opts_lsp.desc = "Go to declaration"
		-- keymap.set("n", "gD", vim.lsp.buf.declaration, opts_lsp) -- go to declaration

		opts_lsp.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts_lsp) -- show lsp definitions

		opts_lsp.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts_lsp) -- show lsp implementations

		-- opts_lsp.desc = "Show LSP type definitions"
		-- keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts_lsp) -- show lsp type definitions

		opts_lsp.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts_lsp) -- see available code actions, in visual mode will apply to selection

		opts_lsp.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts_lsp) -- smart rename

		opts_lsp.desc = "Show signature or HINT"
    keymap.set("i", "<M-k>", function() vim.lsp.buf.signature_help() end, opts_lsp)

		-- opts_lsp.desc = "Show buffer diagnostics"
		-- keymap.set("n", "gf", "<cmd>Telescope diagnostics bufnr=0<CR>", opts_lsp) -- show  diagnostics for file

		opts_lsp.desc = "Show line diagnostics"
		keymap.set("n", "gl", vim.diagnostic.open_float, opts_lsp) -- show diagnostics for line

		-- opts_lsp.desc = "Go to previous diagnostic"
		-- keymap.set("n", "[d", vim.diagnostic.goto_prev, opts_lsp) -- jump to previous diagnostic in buffer

		-- opts_lsp.desc = "Go to next diagnostic"
		-- keymap.set("n", "]d", vim.diagnostic.goto_next, opts_lsp) -- jump to next diagnostic in buffer

		opts_lsp.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts_lsp) -- show documentation for what is under cursor

		opts_lsp.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts_lsp) -- mapping to restart lsp if necessary
	end,
})

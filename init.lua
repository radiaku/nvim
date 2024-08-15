-- disable netrw at the very start of your init.lua
--
--
-- vim.lsp.set_log_level("debug")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0

-- Map Caps Lock to Escape
-- vim.api.nvim_set_keymap("n", "<CapsLock>", "<Esc>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<CapsLock>", "<Esc>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "<CapsLock>", "<Esc>", { noremap = true, silent = true })

-- optionally enable 24-bit colour
-- vim.opt.termguicolors = true

local python_install_path = ""
if vim.fn.has("win32") == 1 then
	python_install_path = vim.fn.exepath("python")
else
	python_install_path = vim.fn.exepath("python3")
end

vim.g.python3_host_prog = python_install_path

-- vim.opt.clipboard = "unnamed"
vim.opt.clipboard = "unnamed,unnamedplus" -- allows neovim to access the system clipboard

if vim.fn.has("win32") == 1 then
	-- Use win32yank for clipboard support
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end

if vim.fn.has("win32") == 1 then
	require("radia.pwsh")
end

require("radia.core")
require("radia.lazy")

-- setting for plugins on here
require("radia.themes")

require("radia.neovide")

-- require("radia.settings")

vim.cmd([[
set mouse=a
" source $VIMRUNTIME/mswin.vim
" imap <S-Insert> <C-R>*
" noremap y "*y
" noremap yy "*yy
" noremap Y "*y$
"
" imap <silent>  <C-R>+
imap <C-v> <C-R>*
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

-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   pattern = "*",
--   callback = function()
--     -- Check if the file contains the pattern "{{.+}}"
--     if vim.fn.search("{{.+}}", "nw") > 0 then
--       -- If the pattern is found, set the filetype to "html"
--       vim.opt_local.filetype = "html"
--     end
--   end
-- })
--

-- vim.cmd([[
--   autocmd BufRead,BufNewFile *.tmpl set filetype=html
-- ]])

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   pattern = { "*.tmpl", "*.gotext", "*.gohtml" },
--   callback = function()
--     print("Filetype set to 'html'")
--     vim.bo.filetype = "html"
--   end,
-- })
--

local function set_filetype()
	local extension = vim.fn.expand("%:e")
	if extension == "tmpl" or extension == "gotext" or extension == "gohtml" then
		vim.bo.filetype = "html"
	end
end

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = set_filetype,
})

-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
--   callback = function()
--     vim.cmd('!notify-send  "hello"')
--     vim.cmd('sleep 10m')
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
-- 	callback = function()
-- 		vim.fn.jobstart('notify-send "hello"', { detach = true })
-- 	end,
-- })

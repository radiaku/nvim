-- vim.g.python3_host_prog = "C:\\python310\\python.exe"
-- vim.opt.clipboard = "unnamed"
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

-- Use win32yank for clipboard support
--vim.g.clipboard = {
--	name = "win32yank-wsl",
--	copy = {
--		["+"] = "win32yank.exe -i --crlf",
--		["*"] = "win32yank.exe -i --crlf",
--	},
--	paste = {
--		["+"] = "win32yank.exe -o --lf",
--		["*"] = "win32yank.exe -o --lf",
--	},
--	cache_enabled = 0,
--}

require("radia.core")
require("radia.lazy")

-- setting for plugins on here
require("radia.themes")

require("radia.neovide")

-- require("radia.settings")

--vim.cmd([[
--set mouse=a
--" source $VIMRUNTIME/mswin.vim
--" imap <S-Insert> <C-R>*
--]])

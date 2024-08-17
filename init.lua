-- disable netrw at the very start of your init.lua
-- vim.lsp.set_log_level("debug")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0

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

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load Core
require("radia.core")
-- Load Lazy
require("radia.lazy")
-- Load Keymaps for plugin etc
require("radia.keymaps")
-- setting themes
require("radia.themes")
-- settings neovide
require("radia.neovide")



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


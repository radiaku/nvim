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


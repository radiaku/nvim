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

vim.opt.smartindent = false

-- cleaning shada
-- vim.api.nvim_create_user_command("ClearShada", function()
-- 	local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
-- 	local files = vim.fn.glob(shada_path .. "/*", false, true)
-- 	local all_success = 0
-- 	for _, file in ipairs(files) do
-- 		local file_name = vim.fn.fnamemodify(file, ":t")
-- 		if file_name == "main.shada" then
-- 			-- skip your main.shada file
-- 			goto continue
-- 		end
-- 		local success = vim.fn.delete(file)
-- 		all_success = all_success + success
-- 		if success ~= 0 then
-- 			vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
-- 		end
-- 		::continue::
-- 	end
-- 	if all_success == 0 then
-- 		vim.print("Successfully deleted all temporary shada files")
-- 	end
-- end, { desc = "Clears all the .tmp shada files" })

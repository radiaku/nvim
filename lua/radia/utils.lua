-- lua/radia/utils.lua
-- Shared utility functions for Neovim configuration

local M = {}

--- Detect if running in Termux (Android terminal emulator)
--- @return boolean true if running in Termux, false otherwise
function M.is_termux()
	local prefix = vim.env.PREFIX or ""
	return prefix:find("com%.termux") ~= nil
end

--- Check if an executable exists in PATH
--- @param bin string The binary name to check
--- @return string|nil The full path to the executable, or nil if not found
function M.exepath(bin)
	local p = vim.fn.exepath(bin)
	return (p ~= "" and p) or nil
end

--- Append a directory to PATH if it exists and isn't already present
--- @param dir string The directory path to append
function M.append_path(dir)
	if vim.fn.isdirectory(dir) == 1 then
		local path = vim.env.PATH or ""
		if not path:find(vim.pesc(dir), 1, true) then
			vim.env.PATH = dir .. ":" .. path
		end
	end
end

--- Find a Python virtual environment directory by walking up the directory tree
--- @param start_dir string The directory to start searching from
--- @return string|nil The path to the venv directory, or nil if not found
function M.find_venv_dir(start_dir)
	-- Walk up from start_dir looking for common venv folders
	local names = { ".venv", "venv", "env", ".env" }
	local dir = start_dir
	while dir and dir ~= "" do
		for _, name in ipairs(names) do
			local candidate = dir .. "/" .. name
			if vim.fn.isdirectory(candidate .. "/bin") == 1 then
				return candidate
			end
		end
		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break
		end
		dir = parent
	end
	return nil
end

--- Find a Python tool binary, checking venv first, then PATH
--- @param bin string The binary name to find (e.g., "black", "pylint")
--- @return string|nil The full path to the binary, or nil if not found
function M.python_venv_bin(bin)
	-- 1) Respect an already-activated venv
	local venv = vim.env.VIRTUAL_ENV
	if venv and venv ~= "" then
		local p = venv .. "/bin/" .. bin
		if vim.fn.executable(p) == 1 then
			return p
		end
	end

	-- 2) Look for venvs relative to buffer dir and cwd
	local search_roots = {}
	local buf_dir = vim.api.nvim_buf_get_name(0)
	if buf_dir ~= "" then
		table.insert(search_roots, vim.fn.fnamemodify(buf_dir, ":p:h"))
	end
	table.insert(search_roots, vim.fn.getcwd())

	for _, root in ipairs(search_roots) do
		local venv_dir = M.find_venv_dir(root)
		if venv_dir then
			local p = venv_dir .. "/bin/" .. bin
			if vim.fn.executable(p) == 1 then
				return p
			end
		end
	end

	-- 3) Fallback to PATH
	return M.exepath(bin)
end

return M

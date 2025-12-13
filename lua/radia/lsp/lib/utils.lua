-- LSP utility functions
local M = {}

-- Check if binary exists on PATH
function M.exepath(bin)
	local p = vim.fn.exepath(bin)
	return p ~= "" and p or nil
end

-- Ensure binary exists, with optional warning in Termux
function M.ensure(bin, hint)
	local p = M.exepath(bin)
	if not p then
		local prefix = vim.env.PREFIX or ""
		local in_termux = prefix:find("com%.termux") ~= nil
		if in_termux then
			vim.notify(string.format("[LSP] '%s' not found on PATH. %s", bin, hint or ""), vim.log.levels.WARN)
		end
		return nil
	end
	return p
end

-- Detect Termux environment
function M.is_termux()
	local prefix = vim.env.PREFIX or ""
	return prefix:find("com%.termux") ~= nil
end

-- Setup diagnostic signs
function M.setup_diagnostic_signs()
	if vim.g.__radia_signs_defined then
		return
	end
	local sev = vim.diagnostic.severity
	local sign_text = {
		[sev.ERROR] = " ",
		[sev.WARN] = " ",
		[sev.INFO] = " ",
		[sev.HINT] = "󰠠 ",
	}
	pcall(function()
		vim.diagnostic.config({
			signs = { text = sign_text },
		})
	end)
	vim.g.__radia_signs_defined = true
end

-- Add project node_modules/.bin to PATH
function M.setup_node_path()
	local project_bin = vim.fn.getcwd() .. "/node_modules/.bin"
	if vim.fn.isdirectory(project_bin) == 1 then
		local path = vim.env.PATH or ""
		if not path:find(vim.pesc(project_bin), 1, true) then
			vim.env.PATH = project_bin .. ":" .. path
		end
	end
end

return M

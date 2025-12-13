-- Common LSP settings and configurations
local M = {}

-- Python diagnostic severity overrides (shared between Mason and direct setups)
M.python_diagnostic_overrides = {
	["reportOptionalSubscript"] = "none",
	["reportOperatorIssue"] = "none",
	["reportOptionalIterable"] = "none",
	["reportArgumentType"] = "none",
	["reportIndexIssue"] = "none",
	["reportGeneralTypeIssues"] = "none",
	["reportAssignmentType"] = "none",
	["reportOptionalOperand"] = "none",
	["reportAttributeAccessIssue"] = "none",
	["reportOptionalMemberAccess"] = "none",
	["reportCallIssue"] = "none",
	["reportUnusedImport"] = "none",
	["reportUnusedParameter"] = "none",
	["reportUnusedVariable"] = "none",
	["reportPrivateImportUsage"] = "none",
}

-- Python venv resolution
function M.resolve_venv(start_dir)
	local venv = vim.env.VIRTUAL_ENV
	if venv and venv ~= "" and vim.fn.isdirectory(venv .. "/bin") == 1 then
		return venv
	end
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

-- Find site-packages for Python
function M.find_site_packages(start_dir, util)
	local root = util.find_git_ancestor(start_dir) or start_dir
	local candidates = {}
	local venv_dir = M.resolve_venv(root)
	if venv_dir then
		table.insert(candidates, venv_dir .. "/lib/python*/site-packages")
	end
	for _, name in ipairs({ ".venv", "venv", "env" }) do
		table.insert(candidates, root .. "/" .. name .. "/lib/python*/site-packages")
	end
	for _, pat in ipairs(candidates) do
		local match = vim.fn.glob(pat, true, true)
		if match and #match > 0 then
			return match[1]
		end
	end
end

-- Get capabilities from blink.cmp or cmp-nvim-lsp
function M.get_capabilities()
	local blink_ok, blink = pcall(require, "blink.cmp")
	if blink_ok then
		return blink.get_lsp_capabilities()
	end
	local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if cmp_ok then
		return cmp_nvim_lsp.default_capabilities()
	end
	error("Neither 'blink.cmp' nor 'cmp_nvim_lsp' could be loaded.")
end

return M

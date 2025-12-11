-- lua/radia/plugins/lsp/none-ls.lua
return {
	{
		"nvimtools/none-ls.nvim", -- formerly null-ls
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local null_ls = require("null-ls")

			-- --- PATH helpers -----------------------------------------------------
			local function append_path(dir)
				if vim.fn.isdirectory(dir) == 1 then
					local path = vim.env.PATH or ""
					if not path:find(vim.pesc(dir), 1, true) then
						vim.env.PATH = dir .. ":" .. path
					end
				end
			end

			local home = vim.env.HOME
			append_path(home .. "/.local/bin") -- pip --user installs (black, pylint)
			append_path(home .. "/.cargo/bin") -- cargo installs (stylua)

			-- --- exe helpers ------------------------------------------------------
			local function exepath(bin)
				local p = vim.fn.exepath(bin)
				return (p ~= "" and p) or nil
			end

			-- Python venv detection: prefer project-local venvs
			local function find_venv_dir(start_dir)
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

			local function python_venv_bin(bin)
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
					local venv_dir = find_venv_dir(root)
					if venv_dir then
						local p = venv_dir .. "/bin/" .. bin
						if vim.fn.executable(p) == 1 then
							return p
						end
					end
				end

				-- 3) Fallback to PATH
				return exepath(bin)
			end

			-- --- sources (conditionally added if available) -----------------------
			local sources = {}

			-- Stylua (Lua formatter)
			do
				local stylua_cmd = exepath("stylua")
				if stylua_cmd then
					table.insert(
						sources,
						null_ls.builtins.formatting.stylua.with({
							command = stylua_cmd,
							extra_args = { "--respect-ignores" },
						})
					)
				end
			end

			-- Black (Python formatter)
			-- do
			-- 	local black_cmd = python_venv_bin("black")
			-- 	if black_cmd then
			-- 		table.insert(
			-- 			sources,
			-- 			null_ls.builtins.formatting.black.with({
			-- 				command = black_cmd,
			-- 			})
			-- 		)
			-- 	end
			-- end

			-- Pylint (Python diagnostics)
			-- do
			-- 	local pylint_cmd = python_venv_bin("pylint")
			-- 	if pylint_cmd then
			-- 		table.insert(
			-- 			sources,
			-- 			null_ls.builtins.diagnostics.pylint.with({
			-- 				command = pylint_cmd,
			-- 				extra_args = {
			-- 					"--disable=missing-module-docstring,missing-function-docstring,missing-class-docstring,unused-import,unused-variable,unused-argument,trailing-newlines,invalid-name",
			-- 				},
			-- 				-- Use builtin args (JSON output, proper stdin handling)
			-- 				method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
			-- 				diagnostics_postprocess = function(d)
			-- 					if d.code then
			-- 						d.message = string.format("[%s] %s", d.code, d.message)
			-- 					end
			-- 				end,
			-- 			})
			-- 		)
			-- 	end
			-- end

			-- Initialize none-ls
			null_ls.setup({
				sources = sources,
				-- keep formatting-on-save to Conform; set to true here only if you don't use Conform
				-- on_attach = function(client, bufnr)
				--   if client.supports_method("textDocument/formatting") then
				--     vim.api.nvim_clear_autocmds({ group = "NoneLsFormat", buffer = bufnr })
				--     vim.api.nvim_create_autocmd("BufWritePre", {
				--       group = vim.api.nvim_create_augroup("NoneLsFormat", { clear = true }),
				--       buffer = bufnr,
				--       callback = function()
				--         vim.lsp.buf.format({ bufnr = bufnr, async = false, timeout_ms = 2000 })
				--       end,
				--     })
				--   end
				-- end,
			})

			-- Friendly notices (optional)
			local missing = {}
			if not exepath("stylua") then
				table.insert(missing, "stylua")
			end
			-- if not python_venv_bin("black") then
			-- 	table.insert(missing, "black")
			-- end
			-- if not python_venv_bin("pylint") then
			-- 	table.insert(missing, "pylint")
			-- end
			if #missing > 0 then
				vim.schedule(function()
					vim.notify(
						("[none-ls] Skipped (not found): %s"):format(table.concat(missing, ", ")),
						vim.log.levels.INFO
					)
				end)
			end
		end,
	},
}

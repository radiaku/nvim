-- lua/radia/plugins/lsp/none-ls.lua
return {
	{
		"nvimtools/none-ls.nvim", -- formerly null-ls
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local null_ls = require("null-ls")
			local utils = require("radia.utils")

			-- Setup PATH for common tool locations
			local home = vim.env.HOME
			utils.append_path(home .. "/.local/bin") -- pip --user installs
			utils.append_path(home .. "/.cargo/bin") -- cargo installs (stylua)

			-- --- sources (conditionally added if available) -----------------------
			local sources = {}

			-- Stylua (Lua formatter)
			do
				local stylua_cmd = utils.exepath("stylua")
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

			-- Initialize none-ls
			null_ls.setup({
				sources = sources,
			})

			-- Friendly notices (optional)
			local missing = {}
			if not utils.exepath("stylua") then
				table.insert(missing, "stylua")
			end
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

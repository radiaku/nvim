return {
	"stevearc/conform.nvim",
	-- optional: pin full hash not short; or just omit "commit"
	commit = "6632e7",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- ---- PATH helpers ------------------------------------------------------
		local function append_path(dir)
			if vim.fn.isdirectory(dir) == 1 then
				local path = vim.env.PATH or ""
				if not path:find(vim.pesc(dir), 1, true) then
					vim.env.PATH = dir .. ":" .. path
				end
			end
		end

		local home = vim.env.HOME
		append_path(home .. "/.local/bin") -- pip --user
		append_path(home .. "/.cargo/bin") -- cargo (stylua)

		-- Node project bin (prettier local install)
		-- Adds ./node_modules/.bin of the current cwd when nvim starts
		local project_bin = vim.fn.getcwd() .. "/node_modules/.bin"
		append_path(project_bin)

		-- Termux-specific
		local is_termux = (vim.env.PREFIX or ""):find("/com.termux/") ~= nil
		if is_termux then
			append_path(vim.env.PREFIX .. "/bin")
		end

		-- ---- exe resolvers -----------------------------------------------------
		local function exepath(bin)
			local p = vim.fn.exepath(bin)
			return p ~= "" and p or bin
		end

		-- Prefer project venv if present
		local function venv_bin(bin)
			local cwd = vim.fn.getcwd()
			local candidates = {
				cwd .. "/.venv/bin/" .. bin,
				cwd .. "/venv/bin/" .. bin,
				cwd .. "/env/bin/" .. bin,
			}
			for _, p in ipairs(candidates) do
				if vim.fn.executable(p) == 1 then return p end
			end
			return exepath(bin)
		end

		local conform = require("conform")
		conform.setup({
			-- format on save (safe defaults).
			-- Enable for all files; Lua uses Stylua (no LSP fallback).
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				local ft = vim.bo[bufnr].filetype
				local opts = { async = false, timeout_ms = 5000, lsp_fallback = true }
				if ft == "lua" then
					-- Avoid LSP formatting for Lua; use Stylua only
					opts.lsp_fallback = false
				end
				return opts
			end,

			formatters_by_ft = {
				javascript      = { "prettier" },
				javascriptreact = { "prettier" },
				json            = { "prettier" },
				markdown        = { "prettier" },
				yaml            = { "prettier" },
				graphql         = { "prettier" },
				lua             = { "stylua" },
				python          = { "isort", "black" },
			},

			formatters = {
				-- Use local project prettier if available (node_modules/.bin), else global
				prettier = {
					command = exepath("prettier"),
				},

				stylua = {
					command = exepath("stylua"),
					prepend_args = {
						"--respect-ignores",
						"--search-parent-directories", -- pick up .stylua.toml up the tree
					},
				},

				isort = {
					command = venv_bin("isort"),
					args = {
						"--line-length", "120",
						"--lines-after-import", "2",
						"--quiet",
						"-",
					},
				},

				black = {
					command = venv_bin("black"),
					-- leaving args empty lets Conform stream via stdin by default;
					-- uncomment to force settings:
					-- args = { "--fast", "--line-length", "120", "--quiet", "-" },
				},
			},
		})

		-- Toggle commands (as you had)
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, { desc = "Disable autoformat-on-save", bang = true })

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, { desc = "Re-enable autoformat-on-save" })
	end,
}

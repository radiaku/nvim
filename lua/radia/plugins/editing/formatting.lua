return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local prefix = vim.fn.stdpath("data") .. "/mason/bin/"
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				-- html = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				gdscript = { "gdformat" },
				python = { "isort", "black" },
			},

			formatters = {
				gdtoolkit = {
					command = "gdformat",
					args = { "$FILENAME" },
					-- args = function(bufnr)
					-- 	return { vim.api.nvim_buf_get_name(bufnr) } -- Dynamic file name
					-- end,
					stdin = true,
					require_cwd = false,
				},

				isort = {
					command = "isort",
					args = {
						"--line-length",
						"120",
						"--lines-after-import",
						"2",
						"--quiet",
						"-",
					},
				},
				black = {
					command = "black",
					-- args = {
					--        "--fast",
					-- 	"--line-length",
					-- 	"120",
					-- 	"--quiet",
					-- 	"-",
					-- },
				},
			},

			-- format_on_save = function(bufnr)
			-- 	-- Disable with a global or buffer-local variable
			-- 	-- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			-- 	-- 	return
			-- 	-- elseif BufIsBig then
			-- 	-- 	return
			-- 	-- end
			-- 	return { async = false, timeout_ms = 500, lsp_fallback = true }
			-- end,

			-- lsp_fallback = true,
			-- async = false,
			-- timeout_ms = 500,
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}

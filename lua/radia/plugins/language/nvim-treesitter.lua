return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ok, treesitter = pcall(require, "nvim-treesitter")
			if not ok then
				vim.notify("nvim-treesitter not loaded", vim.log.levels.ERROR)
				return
			end

			local ensure_installed = {
				"json",
				"javascript",
				"html",
				"go",
				"php",
				"python",
				"css",
				"bash",
				"lua",
				"vim",
				"vimdoc",
				"gitignore",
				"query",
			}

			treesitter.setup({
				install_dir = vim.fn.stdpath("data") .. "/site/parser",
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyDone",
				once = true,
				callback = function()
					local installed = treesitter.get_installed("parsers")
					local missing = vim.tbl_filter(function(lang)
						return not vim.list_contains(installed, lang)
					end, ensure_installed)

					if #missing > 0 then
						treesitter.install(missing)
					end
				end,
			})

			local max_size = 500000

			local start_group = vim.api.nvim_create_augroup("RadiaTreesitterStart", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = start_group,
				callback = function(args)
					local bufnr = args.buf

					if vim.bo[bufnr].buftype ~= "" then
						return
					end

					local ok_size, byte_size = pcall(function()
						return vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
					end)

					if not ok_size or byte_size > max_size then
						return
					end

					pcall(vim.treesitter.start, bufnr)
				end,
			})
		end,
	},
}

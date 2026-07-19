return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if not ok then
				vim.notify("nvim-treesitter not loaded", vim.log.levels.ERROR)
				return
			end

			configs.setup({
				ensure_installed = {
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
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max_size = 500000
						local ok_size, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok_size and stats and stats.size > max_size then
							return true
						end
						local ok_offset, byte_size = pcall(function()
							return vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
						end)
						return ok_offset and byte_size > max_size
					end,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},
}

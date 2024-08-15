return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		-- local colors = require("cyberdream.colors").default
		-- local cyberdream = require("lualine.themes.cyberdream")
		-- local tokyonight = require("lualine.themes.tokyonight")
		-- local monet = require("lualine.themes.monet")
		-- local sonokai = require("lualine.themes.sonokai")
		return {
			options = {
				component_separators = { left = " ", right = " " },
				theme = "sonokai",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},
			sections = {
				lualine_a = { { "mode", icon = "", icon_only = true } },
				lualine_b = { { "branch", icon = "", icon_only = true } },
				lualine_c = {
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{
						"filename",
						path = 3,
						symbols = { modified = "  ", readonly = "", unnamed = "" },
					},
					{
						function()
							return require("lsp-progress").progress()
						end,
					},
				},

				lualine_y = {
					-- {
					-- 	require("lazy.status").updates,
					-- 	cond = require("lazy.status").has_updates,
					-- 	color = { fg = colors.green },
					-- },
					{ "diff" },
					-- {
					-- 	"location",
					-- 	color = { fg = colors.cyan, bg = colors.none },
					-- },
				},
				-- lualine_z = {
				-- 	function()
				-- 		return "  " .. os.date("%X") .. " 🚀 "
				-- 	end,
				-- },
			},

			extensions = { "toggleterm", "mason", "nvim-tree", "neo-tree", "trouble" },
		}
	end,
}

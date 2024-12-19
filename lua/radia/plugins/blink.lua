return {
	"saghen/blink.cmp",

	version = "v0.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		"rafamadriz/friendly-snippets", -- useful snippets
	},
	opts = {
		keymap = { preset = "default", ["<CR>"] = { "select_and_accept" } },
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		snippets = {
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
			active = function(filter)
				if filter and filter.direction then
					return require("luasnip").jumpable(filter.direction)
				end
				return require("luasnip").in_snippet()
			end,
			jump = function(direction)
				require("luasnip").jump(direction)
			end,
		},
		sources = {
			default = { "lsp", "path", "luasnip", "buffer" },
		},
	},
}

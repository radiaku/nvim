return {
	"saghen/blink.cmp",

	version = "v0.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		"rafamadriz/friendly-snippets", -- useful snippets
	},
	opts = {
		keymap = {
			preset = "default",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			-- ["<Tab>"] = { "snippet_forward", "fallback" },
			-- ["<S-Tab>"] = { "snippet_backward", "fallback" },

			-- ["<Up>"] = { "select_prev", "fallback" },
			-- ["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			-- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
			-- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		-- trigger = {
		-- 	-- When false, will not show the completion window automatically when in a snippet
		-- 	show_in_snippet = true,
		-- 	-- When true, will show the completion window after typing a character that matches the `keyword.regex`
		-- 	show_on_keyword = true,
		-- },

		completion = {
			list = {
				max_items = 20,
				selection = "auto_insert",
				-- Controls how the completion items are selected
				-- 'preselect' will automatically select the first item in the completion list
				-- 'manual' will not select any item by default
				-- 'auto_insert' will not select any item by default, and insert the completion items automatically
				-- when selecting them
				cycle = {
					from_bottom = true,
					from_top = true,
				},
			},
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

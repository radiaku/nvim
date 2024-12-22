return {
	"saghen/blink.cmp",

	version = "v0.7.6",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets", -- useful snippets
	},
	opts = {
		opts_extend = { "sources.completion.enabled_providers" },
		keymap = {
			preset = "default",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		completion = {
			list = {
				max_items = 100,
				selection = "auto_insert",
				cycle = {
					from_bottom = true,
					from_top = true,
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 100,
			},
			-- ghost_text = { enabled = true },
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
			default = { "lsp", "luasnip", "snippets", "path", "buffer" },
			-- providers = {
			-- 	lsp = {
			-- 		name = "lsp",
			-- 		enabled = true,
			-- 		module = "blink.cmp.sources.lsp",
			-- 		kind = "LSP",
			-- 		score_offset = 1000,
			-- 	},
			-- 	luasnip = {
			-- 		name = "luasnip",
			-- 		enabled = true,
			-- 		module = "blink.cmp.sources.luasnip",
			-- 		score_offset = 950,
			-- 	},
			-- 	snippets = {
			-- 		name = "snippets",
			-- 		min_keyword_length = 2, -- don't show when triggered manually, useful for JSON keys
			-- 		enabled = true,
			-- 		module = "blink.cmp.sources.snippets",
			-- 		score_offset = 950,
			-- 	},
				-- buffer = {
				-- 	fallback_for = {}, -- disable being fallback for LSP
				-- 	max_items = 4,
				-- 	min_keyword_length = 4,
				-- 	score_offset = -3,
				-- },
			-- },
		},
	},
}

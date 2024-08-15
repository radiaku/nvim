return {
	"L3MON4D3/LuaSnip",
	build = "make install_jsregexp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
	config = function(_, opts)
		local ls = require("luasnip")
		local extends = {
			["typescript"] = { "javascriptreact" },
			["javascript"] = { "javascript" },
			["javascriptreact"] = { "javascriptreact" },
			["typescriptreact"] = { "javascriptreact" },
			-- ["lua"] = { "luadoc" },
			-- ["go"] = { "godoc" },
			-- ["python"] = { "pydoc" },
			-- ["rust"] = { "rustdoc" },
			-- ["cs"] = { "csharpdoc" },
			-- ["java"] = { "javadoc" },
			-- ["c"] = { "cdoc" },
			-- ["cpp"] = { "cppdoc" },
			-- ["php"] = { "phpdoc" },
			-- ["kotlin"] = { "kdoc" },
			-- ["ruby"] = { "rdoc" },
			-- ["sh"] = { "shelldoc" },
		}

		ls.setup(opts)
		require("luasnip.loaders.from_vscode").lazy_load()

		for k, v in ipairs(extends) do
			ls.filetype_extend(k, v)
		end
	end,
}

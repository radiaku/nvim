return {
	"L3MON4D3/LuaSnip",
	-- version = "v2.*",
	build = vim.fn.has("win32") == 1 and "pwsh " .. vim.fn.stdpath("config") .. vim.fn.expand("/lua/radia/windows/ps_luasnip_build_mingw.ps1")
		or "make install_jsregexp",

  -- first time install
  -- cd $env:LOCALAPPDATA
  -- cd ~/AppData/Local/nvim-data/lazy/LuaSnip
  -- & $env:LOCALAPPDATA/nvim/lua/radia/windows/ps_luasnip_build.ps1
	-- build = "make install_jsregexp",
	-- build = "make install_jsregexp CC=gcc.exe SHELL=C:/Program Files/Git/bin/sh.exe .SHELLFLAGS=-c",

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

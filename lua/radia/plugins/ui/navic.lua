return {
	"SmiteshP/nvim-navic",
	config = function()
		require("nvim-navic").setup({

			icons = {
				File = " ",
				Module = " ",
				Namespace = "󰌗 ",
				Package = " ",
				Class = "󰌗 ",
				Method = "󰆧 ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = "󰕘",
				Interface = "󰕘",
				Function = "󰊕 ",
				Variable = "󰆧 ",
				Constant = "󰏿 ",
				String = "󰀬 ",
				Number = "󰎠 ",
				Boolean = "◩ ",
				Array = "󰅪 ",
				Object = "󰅩 ",
				Key = "󰌋 ",
				Null = "󰟢 ",
				EnumMember = " ",
				Struct = "󰌗 ",
				Event = " ",
				Operator = "󰆕 ",
				TypeParameter = "󰊄 ",
			},
			lsp = {
				auto_attach = true,
				preference = nil,
			},
			highlight = true,
			separator = " > ",
			depth_limit = 0,
			depth_limit_indicator = "..",
		})

		-- Safe wrapper: winbar eval runs on every redraw. After bulk external
		-- reloads, bare get_location() can throw → red ErrorMsg flood.
		_G.RadiaNavicLocation = function()
			local ok, navic = pcall(require, "nvim-navic")
			if not ok or not navic.is_available() then
				return ""
			end
			local ok_loc, loc = pcall(navic.get_location)
			if not ok_loc or type(loc) ~= "string" then
				return ""
			end
			return loc
		end
		vim.o.winbar = " %{%v:lua.RadiaNavicLocation()%}"
	end,
}

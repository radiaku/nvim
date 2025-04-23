return {
	"ray-x/go.nvim",
	commit = "ef38820e413e10f47d83688dee41785bd885fb2a",
	-- commit =   "d78319",
	dependencies = {
		"ray-x/guihua.lua",
	},
	config = function()
		require("go").setup({
			lsp_codelens = false,
			lsp_inlay_hints = {
				enable = false,
			},
		})
	end,
	event = { "CmdlineEnter" },
	filetypes = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}

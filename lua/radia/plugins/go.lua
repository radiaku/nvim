return {
	"ray-x/go.nvim",
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

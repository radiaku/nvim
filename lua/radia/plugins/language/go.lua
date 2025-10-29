return {
	"ray-x/go.nvim",
	commit = "ef38820e413e10f47d83688dee41785bd885fb2a",
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
	build = function()
		if vim.fn.executable("go") == 1 then
			require("go.install").update_all_sync()
		else
			vim.notify("Go is not installed or not in PATH", vim.log.levels.WARN)
		end
	end,
}

return {
	"LunarVim/bigfile.nvim",
	event = "BufReadPre",
	config = function()
		require("bigfile").setup({
			filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
			pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
			features = {
				"indent_blankline",
				"illuminate",
				"highlight",
				"lsp",
				"treesitter",
				"syntax",
				"matchparen",
				"vimopts",
				"filetype",
			},
		})
	end,
}

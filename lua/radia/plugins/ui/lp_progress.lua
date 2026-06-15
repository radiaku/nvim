-- lua
return {
	"linrongbin16/lsp-progress.nvim",
	commit = "f3df1d",
	event = "LspAttach",
	config = function()
		require("lsp-progress").setup({})
		--
	end,
}

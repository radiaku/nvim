return {
	"OmniSharp/omnisharp-vim",
	config = function()
		local lsp_server_omnisharp = vim.fn.expand("$HOME/.config/omnisharp/omnisharp.exe")
		vim.g.OmniSharp_server_path = lsp_server_omnisharp
	end,
}

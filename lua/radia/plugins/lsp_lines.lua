return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	config = function()
		require("lsp_lines").setup()

		-- Disable virtual_text since it's redundant due to lsp_lines.
		vim.diagnostic.config({
			virtual_text = false,
		})

		vim.lsp.handlers["textDocument/publishDiagnostics"] =
			vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

		vim.keymap.set("", "<Leader>ll", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })

		vim.cmd([[autocmd! CursorHold * lua vim.diagnostic.config({ virtual_lines = { only_current_line = true } })]])
	end,
}

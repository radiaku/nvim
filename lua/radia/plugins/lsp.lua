-- LSP configuration loader
-- Actual LSP configs are in lua/radia/lsp/ to keep them organized
return {
	require("radia.lsp.lspconfig"),
	require("radia.lsp.mason"),
	require("radia.lsp.none-ls"),
}

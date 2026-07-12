# LSP — direct path (Termux)

The Termux branch of [[30-lsp-architecture]]. Mason isn't used on Android/Termux, so servers installed system-wide (via `pkg`, `npm -g`, etc.) are wired up **directly**.

- Triggered only when `utils.is_termux()` is true, from `lspconfig.lua`. → [[50-termux-detection]]
- Config: `lua/radia/lsp/lib/direct.lua` — checks for each binary on PATH and calls `lspconfig[server].setup(...)` directly.
- Uses `utils.ensure(bin, hint)`, which on Termux **emits a `vim.notify` warning** when a binary is missing (with an install hint). On desktop the same helper stays silent. → [[33-lsp-shared-libs]]

Same server set as the Mason path, plus Termux-specific install hints. Keep the two in sync. → [[31-lsp-mason-path]]

File: `lua/radia/lsp/lib/direct.lua`

Links: [[30-lsp-architecture]] · [[31-lsp-mason-path]] · [[50-termux-detection]] · [[33-lsp-shared-libs]]

Tags: [[tags#lsp|#lsp]] · [[tags#platform|#platform]]

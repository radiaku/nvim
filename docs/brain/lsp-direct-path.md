# LSP — direct path (Termux)

The Termux branch of [[lsp-architecture]]. Mason isn't used on Android/Termux, so servers installed system-wide (via `pkg`, `npm -g`, etc.) are wired up **directly**.

- Triggered only when `utils.is_termux()` is true, from `lspconfig.lua`. → [[termux-detection]]
- Config: `lua/radia/lsp/lib/direct.lua` — checks for each binary on PATH and calls `lspconfig[server].setup(...)` directly.
- Uses `utils.ensure(bin, hint)`, which on Termux **emits a `vim.notify` warning** when a binary is missing (with an install hint). On desktop the same helper stays silent. → [[lsp-shared-libs]]

Same server set as the Mason path, plus Termux-specific install hints. Keep the two in sync. → [[lsp-mason-path]]

File: `lua/radia/lsp/lib/direct.lua`

Links: [[lsp-architecture]] · [[lsp-mason-path]] · [[termux-detection]] · [[lsp-shared-libs]]

#lsp #platform

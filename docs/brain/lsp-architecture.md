# LSP architecture

The hub note for LSP. The central design choice: **two parallel setup paths**, one config.

LSP code lives in `lua/radia/lsp/` — deliberately *outside* `plugins/` so lazy.nvim does not auto-import the helper modules. `core/init.lua` pulls them in with explicit `require()` calls. → [[lazy-bootstrap]]

`lspconfig.lua` orchestrates and **chooses the path at runtime**:

- Desktop → Mason-managed servers via `mason_lspconfig.setup_handlers(...)`. → [[lsp-mason-path]]
- Termux (`utils.is_termux()`) → system binaries on PATH, bypassing Mason. → [[lsp-direct-path]] · [[termux-detection]]

Both paths share `lib/settings.lua` and `lib/utils.lua`. → [[lsp-shared-libs]]

> **Rule:** a language server's config must be kept in sync across **both** `lib/handlers.lua` (Mason) and `lib/direct.lua` (Termux). Changing one without the other drifts desktop and mobile apart.

Per-server breakdown: `lua/radia/lsp/README.md`.

Links: [[lsp-mason-path]] · [[lsp-direct-path]] · [[lsp-shared-libs]] · [[termux-detection]] · [[index]]

#lsp #platform #core

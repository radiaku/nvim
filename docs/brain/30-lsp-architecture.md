# LSP architecture

The hub note for LSP. The central design choice: **two parallel setup paths**, one config.

LSP code lives in `lua/radia/lsp/` — deliberately *outside* `plugins/` so lazy.nvim does not auto-import the helper modules. `core/init.lua` pulls them in with explicit `require()` calls. → [[11-lazy-bootstrap]]

`lspconfig.lua` orchestrates and **chooses the path at runtime**:

- Desktop → Mason-managed servers via `mason_lspconfig.setup_handlers(...)`. → [[31-lsp-mason-path]]
- Termux (`utils.is_termux()`) → system binaries on PATH, bypassing Mason. → [[32-lsp-direct-path]] · [[50-termux-detection]]

Both paths share `lib/settings.lua` and `lib/utils.lua`. → [[33-lsp-shared-libs]]

Before either path attaches, a guard skips buffers whose file is missing on disk. → [[34-lsp-deleted-file-guard]]

> **Rule:** a language server's config must be kept in sync across **both** `lib/handlers.lua` (Mason) and `lib/direct.lua` (Termux). Changing one without the other drifts desktop and mobile apart.

Per-server breakdown: `lua/radia/lsp/README.md`.

Links: [[31-lsp-mason-path]] · [[32-lsp-direct-path]] · [[33-lsp-shared-libs]] · [[34-lsp-deleted-file-guard]] · [[50-termux-detection]] · [[index]]

Tags: [[tags#lsp|#lsp]] · [[tags#platform|#platform]] · [[tags#core|#core]]

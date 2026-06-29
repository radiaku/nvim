# LSP — Mason path (desktop)

The desktop branch of [[lsp-architecture]]. On non-Termux systems, servers are installed and managed by **Mason** (`:Mason`), and configured through handlers.

- Entry: `mason.setup({ PATH = "prepend" })` then `mason_lspconfig.setup_handlers(handlers.setup(lspconfig, capabilities, util))` in `lspconfig.lua`.
- Server configs: `lua/radia/lsp/lib/handlers.lua`. A table keyed by server name; a default handler covers everything not explicitly listed.
- Explicit handlers: `lua_ls`, `basedpyright`, `gopls`, `vtsls`, `html`, `tailwindcss`, `intelephense`, `kotlin_language_server`, `clangd`, `templ`, `omnisharp`, `theme_check`, `emmet_ls`, `emmet_language_server`, `jsonls`.

Each handler typically resolves its binary via `utils.exepath(...)` and **silently returns if absent** — so a missing server just doesn't load (no error). → [[verification]] · [[lsp-shared-libs]]

Mirror any change here into the Termux path. → [[lsp-direct-path]]

File: `lua/radia/lsp/lib/handlers.lua`

Links: [[lsp-architecture]] · [[lsp-direct-path]] · [[lsp-shared-libs]]

#lsp #platform

# Filetype overrides

`lua/radia/last.lua` (step 5 of [[load-order]]) registers a `BufEnter` autocmd that remaps filetypes by extension:

- `.tmpl`, `.gotext`, `.gohtml` → `html`
- `.mq5` → `cpp` (MetaTrader MQL5 treated as C++)

The same file also has a `VimEnter` autocmd that **cleans stale ShaDa temp files** (`main.shada.tmp.*`) to prevent the `E138` error on startup.

These remaps feed downstream tooling: e.g. the LSP/Treesitter that handle `html`/`cpp` then apply to these extensions. → [[lsp-architecture]]

File: `lua/radia/last.lua`

Links: [[load-order]] · [[lsp-architecture]] · [[index]]

#core #platform

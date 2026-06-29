# LSP — shared libs

Both LSP paths draw from the same helpers in `lua/radia/lsp/lib/`, which is why desktop and Termux stay behaviorally identical where it matters. → [[lsp-architecture]]

- **`utils.lua`**
  - `exepath(bin)` — return PATH location or nil.
  - `ensure(bin, hint)` — like exepath, but warns via `vim.notify` **only on Termux** when missing. → [[lsp-direct-path]]
  - `is_termux()` — `vim.env.PREFIX` contains `com.termux`. → [[termux-detection]]
  - `setup_diagnostic_signs()` — diagnostic sign glyphs (guarded by a global so it runs once).
  - `setup_node_path()` — prepends project `node_modules/.bin` to PATH.
- **`settings.lua`**
  - `get_capabilities()` — from blink.cmp or cmp-nvim-lsp.
  - `python_diagnostic_overrides` — shared basedpyright/python severity tweaks.
  - `resolve_venv()` / `find_site_packages()` — Python env detection.
- **`handlers.lua`** → [[lsp-mason-path]] · **`direct.lua`** → [[lsp-direct-path]]

Files: `lua/radia/lsp/lib/*.lua`. See also `lua/radia/lsp/README.md`.

Links: [[lsp-architecture]] · [[lsp-mason-path]] · [[lsp-direct-path]] · [[termux-detection]]

#lsp #platform

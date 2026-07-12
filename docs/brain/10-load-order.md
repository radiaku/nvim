# Load order

`init.lua` requires five modules in a **strict, deliberate order**. Leader keys and the plugin bootstrap must run before anything that depends on plugins.

1. `radia.core` — sets nothing-yet-depends-on-plugins up: bootstraps lazy.nvim, clipboard, platform detection, then **calls `lazy.setup()` with every plugin import**, then loads `radia.core.settings`. → [[11-lazy-bootstrap]]
2. `radia.keymaps` — keymaps, loaded *after* plugins exist. → [[40-keymaps]]
3. `radia.themes` — applies the colorscheme from `_G.themesname`. → [[41-theme-system]]
4. `radia.neovide` — GUI-only settings.
5. `radia.last` — final autocmds: filetype remaps + ShaDa temp cleanup. → [[53-filetype-overrides]]

Leader keys (`vim.g.mapleader = " "`) are set at the very top of `init.lua`, before step 1 — changing them later would be too late for plugins.

Files: `init.lua`, `lua/radia/core/init.lua`

Links: [[index]] · [[11-lazy-bootstrap]] · [[41-theme-system]]

Tags: [[tags#core|#core]] · [[tags#workflow|#workflow]]

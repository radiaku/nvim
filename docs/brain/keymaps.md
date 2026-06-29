# Keymaps

Keymaps load at step 2 of [[load-order]] — *after* plugins, so they can reference plugin commands. `lua/radia/keymaps/init.lua` requires three files in order:

1. `default.lua` — base/vanilla mappings.
2. `custom.lua` — personal overrides and plugin-aware maps.
3. `custom_function.lua` — maps that call helper functions.

Supporting file: `keymaps/helper.lua` (shared helpers used by the above).

Leader is `<space>` for both `mapleader` and `maplocalleader`, set in `init.lua` before plugins load (must precede plugin setup). → [[load-order]]

Discover live maps in Neovim: `:Telescope keymaps` or `<leader>fm`. Human-readable overview: `installer/05-neovim-keymaps.md`.

Files: `lua/radia/keymaps/*.lua`

Links: [[load-order]] · [[index]]

#keymaps #core

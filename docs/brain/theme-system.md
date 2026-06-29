# Theme system

The active colorscheme flows through a global: `_G.themesname`.

- **Set** in `lua/radia/core/init.lua`: `local themesname = "sonokai"` → `_G.themesname = themesname`. It's also passed to lazy's `install.colorscheme`. This is the file to edit to switch themes.
- **Applied** in `lua/radia/themes.lua`: reads `_G.themesname`, calls the theme's `.setup()` under Neovide/GUI, then `colorscheme <name>` with a `default` fallback on failure.

Gotcha: `themes.lua` only *applies* the theme — it does **not** decide which one. Editing the string in `themes.lua` won't change the theme; edit `core/init.lua`.

Available theme plugins live in `plugins/ui/theme_*.lua` (tokyonight, cyberdream, gruvbox, sonokai). → [[plugin-organization]]

Application happens at step 3 of [[load-order]], after plugins load.

Links: [[load-order]] · [[plugin-organization]] · [[index]]

#theme #core

# lazy.nvim bootstrap

`lua/radia/core/init.lua` self-installs lazy.nvim if missing (git clone of the `stable` branch into `stdpath("data")/lazy/lazy.nvim`), prepends it to `rtp`, then calls `require("lazy").setup({...})`.

The setup table is a list of **category imports** plus three explicit LSP requires:

```lua
{ import = "radia.plugins" },        -- and .ui, .files, .navigation, .git,
{ import = "radia.plugins.ui" },     -- .editing, .diagnostics, .language,
...                                  -- .terminal, .session, .tools, .notes
require("radia.lsp.mason"),
require("radia.lsp.lspconfig"),
require("radia.lsp.none-ls"),
```

Two things to know:
- Each `{ import }` line maps to a folder under `plugins/`. Adding a new top-level category folder requires adding a matching line here, or it stays invisible. → [[plugin-organization]]
- LSP is `require`'d directly (not imported as a folder) on purpose, so lazy doesn't auto-load the helper modules. → [[lsp-architecture]]

`checker.enabled = false` (no auto update checks); `change_detection.notify = true`.

File: `lua/radia/core/init.lua`

Links: [[load-order]] · [[plugin-organization]] · [[lsp-architecture]] · [[theme-system]]

#core #plugins

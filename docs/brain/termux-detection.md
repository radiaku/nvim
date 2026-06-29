# Termux detection

The single switch that makes this config Android-aware. Detection is by environment variable:

```lua
(vim.env.PREFIX or ""):find("com%.termux") ~= nil
```

Canonical home: `utils.is_termux()` in `lua/radia/lsp/lib/utils.lua`, but the same `PREFIX`/`com.termux` check is inlined in several places (clipboard, plugin build steps).

Drives behavior across the config:
- LSP setup path selection. → [[lsp-direct-path]] vs [[lsp-mason-path]]
- Whether missing-binary warnings fire. → [[lsp-shared-libs]]
- Clipboard provider choice. → [[clipboard]]
- Build commands for native plugins (e.g. telescope-fzf-native uses clang on Termux).

Sibling platform switch: Windows uses `vim.fn.has("win32")`. → [[windows-pwsh]]

Links: [[lsp-architecture]] · [[clipboard]] · [[windows-pwsh]] · [[index]]

#platform

# Clipboard

Clipboard setup in `core/init.lua` does two non-obvious things:

1. **Deferred enable.** `clipboard` starts empty (`""`), then on `UIEnter` (once) a `defer_fn(..., 50ms)` sets `clipboard = "unnamedplus"`. This avoids a slow clipboard-provider probe blocking startup.

2. **Termux provider.** When `vim.env.PREFIX` is a `com.termux` path and `termux-clipboard-set`/`-get` exist, `vim.g.clipboard` is wired to those binaries (`+` and `*` registers). If the tools are missing, it `vim.notify`s to install the Termux:API app + `termux-api`. → [[50-termux-detection]]

File: `lua/radia/core/init.lua`

Links: [[50-termux-detection]] · [[10-load-order]] · [[index]]

Tags: [[tags#platform|#platform]] · [[tags#core|#core]]

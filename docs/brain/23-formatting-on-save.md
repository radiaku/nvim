# Format on save (conform.nvim)

Format-on-save is owned by **conform.nvim** — `lua/radia/plugins/editing/formatting.lua` (loaded as a plugin spec, step of [[10-load-order]] via [[20-plugin-organization]]). This is separate from [[30-lsp-architecture]]'s none-ls path: `lua/radia/lsp/none-ls.lua` only wires **stylua** and does no on-save formatting.

Key pieces of the conform spec:

- `formatters_by_ft` — per-filetype chains. Python = `isort` → `black`; JS/JSON/MD/YAML/GraphQL = `prettier`; `lua` = `stylua`; `gdscript` = `gdformat`.
- `format_on_save(bufnr)` returns `{ async = false, timeout_ms = 3000, lsp_fallback = true }`. `async = false` is required so formatting runs *before* the write. Skips when `vim.g/vim.b.disable_autoformat` is set or the file is >5 MiB.
- Commands `:FormatDisable[!]` / `:FormatEnable` toggle `disable_autoformat` (global, or buffer-local with `!`).
- `notify_on_error = false` — suppresses conform's error/timeout notifications.

## Windows gotcha: black timeout → libuv "handle is already closing"

`black` is a Python cold start; on Windows the first save easily exceeds a tight `timeout_ms`. When conform kills the timed-out job it trips a **Neovim core libuv race** (`vim/_system.lua` — timeout handler and exit callback both `close()` the same handle), surfacing:

```
Formatter 'black' timeout
Error executing luv callback: ... handle ... is already closing
```

The file still gets written; only the format is aborted. Fixes:
- Raising `timeout_ms` (was 500, now 3000) avoids the kill path → the luv traceback is a *core* error (not a `vim.notify`), so it can only be silenced by not timing out, **not** by `notify_on_error`.
- `notify_on_error = false` hides conform's own `Formatter 'black' timeout` warning.

File: `lua/radia/plugins/editing/formatting.lua`

Links: [[10-load-order]] · [[20-plugin-organization]] · [[30-lsp-architecture]] · [[51-windows-pwsh]] · [[index]]

Tags: [[tags#plugins|#plugins]] · [[tags#platform|#platform]]

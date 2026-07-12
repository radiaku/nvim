# LSP deleted-file guard

Covers **both directions** of the file-deleted-outside-nvim problem:

1. **Deleted before open** (stale oldfiles entry, restored session, harpoon mark): language servers used to attach to a buffer with no file behind it and could error. The guard makes LSP simply **not attach** to such buffers.
2. **Deleted while open and attached**: the buffer and its servers are fine (servers work from buffer content, not disk), but the moment nvim notices (focus regain, `:checktime`) it throws **`E211: File no longer available`**. The guard replaces that with a quiet `vim.notify` warning, keeps the buffer (marked modified, mirroring the default), and `:w` recreates the file.

Lives in `lua/radia/lsp/lib/guard.lua`, called from `lspconfig.lua` (`guard.setup()`) before any server setup.

How it works (deleted before open):

- Every lspconfig server — Mason path *and* Termux direct path — attaches through `lspconfig.manager:try_add`. All manager instances resolve methods via `__index` on the module table, so **one monkey-patch of `manager.try_add` gates every server**. → [[30-lsp-architecture]]
- The patch skips attach when the buffer is a normal file buffer (`buftype == ""`, non-empty name) whose path fails `filereadable()`, and marks it `vim.b.radia_lsp_deferred`.
- A `BufWritePost` autocmd (`RadiaLspGuard` group) watches deferred buffers: once the file exists on disk (first `:w`), it runs `:LspStart` so servers attach normally.

How it works (deleted while attached):

- A `FileChangedShell` autocmd handles `v:fcs_reason == "deleted"` itself: `v:fcs_choice = ""` suppresses E211, the buffer is set `modified`, and a warning is notified. Every other reason (contents changed, mode, timestamp) falls back to default behavior via `v:fcs_choice = "ask"`.
- LSP clients are deliberately **left attached** in this case — completion/diagnostics keep working off the buffer until the user recreates (`:w`) or abandons the file.

Consequences / gotchas:

- **New unsaved files also match** (nvim can't distinguish "deleted" from "not yet created") — they get LSP only after the first save. Acceptable trade-off.
- `null-ls` (none-ls) bypasses lspconfig's manager, so it still attaches — harmless, it's in-process and formats from buffer contents, never the disk path.
- The patch targets the pinned lspconfig's manager API ([[22-pinned-commits]]); if the lspconfig pin is ever bumped past the manager-based architecture (it was removed upstream in favor of `vim.lsp.config`), the guard needs reworking — its `pcall(require, "lspconfig.manager")` fails soft, meaning the guard silently stops gating rather than erroring.

Links: [[30-lsp-architecture]] · [[22-pinned-commits]] · [[index]]

Tags: [[tags#lsp|#lsp]] · [[tags#gotcha|#gotcha]]

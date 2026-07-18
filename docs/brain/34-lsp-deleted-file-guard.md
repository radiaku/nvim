# LSP guard + external disk changes

Covers **three** outside-nvim file problems:

1. **Deleted before open** (stale oldfiles entry, restored session, harpoon mark): language servers used to attach to a buffer with no file behind it and could error. The guard makes LSP simply **not attach** to such buffers.
2. **Deleted while open and attached**: the buffer and its servers are fine (servers work from buffer content, not disk), but the moment nvim notices (focus regain, `:checktime`) it throws **`E211: File no longer available`**. The guard suppresses E211, keeps the buffer (marked modified), and `:w` recreates the file.
3. **Modified externally while open** (Claude, CommandCode, git checkout): many open buffers used to hit `v:fcs_choice = "ask"` per file → prompt/error spam on every `checktime`/movement until hard-close. Clean buffers now **silent-reload**; dirty+disk-changed buffers keep local work (`conflict`).

Lives in `lua/radia/lsp/lib/guard.lua`, called from `lspconfig.lua` (`guard.setup()`) before any server setup. `opt.autoread = true` is set in `settings.lua` (harmless; `FileChangedShell` still owns the real path).

How it works (deleted before open):

- Every lspconfig server — Mason path *and* Termux direct path — attaches through `lspconfig.manager:try_add`. All manager instances resolve methods via `__index` on the module table, so **one monkey-patch of `manager.try_add` gates every server**. → [[30-lsp-architecture]]
- The patch skips attach when the buffer is a normal file buffer (`buftype == ""`, non-empty name) whose path fails `filereadable()`, and marks it `vim.b.radia_lsp_deferred`.
- A `BufWritePost` autocmd (`RadiaLspGuard` group) watches deferred buffers: once the file exists on disk (first `:w`), it runs `:LspStart` so servers attach normally.

How it works (FileChangedShell — critical):

- Defining **any** `FileChangedShell` autocmd **disables Neovim's default autoread path**. Every reason must set `v:fcs_choice` or nvim freezes on prompts.
- `deleted` → `fcs_choice = ""`, mark modified, batch notify.
- `conflict` or buffer already `modified` → `fcs_choice = ""` (keep local; never clobber unsaved edits).
- clean buffer + disk changed (`changed` / `mode` / `time`) → `fcs_choice = "reload"`.
- Notices are **batched** (~200ms) so multi-file external edits become one `Disk change: N reloaded` notify, not N messages.

Detection:

- `FocusGained` / `TermClose` / `TermLeave` / `CursorHold` run a re-entrancy-safe `:checktime` (skipped in insert/cmdline).
- Without these, nvim only notices on write/certain ops — stale buffers + false LSP errors pile up until you move around and everything explodes.

Session restore (auto-session) is case 1: the session's `edit` of a missing file silently creates an empty `[New]` buffer — no E211. The guard marks that buffer deferred. `post_restore_cmds` in `lua/radia/plugins/session/autosession.lua` also wipes unmodified missing-file phantoms after restore.

Consequences / gotchas:

- **New unsaved files also match** the missing-file gate (nvim can't distinguish "deleted" from "not yet created") — they get LSP only after the first save.
- Dirty buffer + external rewrite keeps **local** content; user must resolve manually (`:e!` to take disk, or `:w!` to overwrite disk).
- `null-ls` (none-ls) bypasses lspconfig's manager — still attaches; harmless.
- The patch targets the pinned lspconfig manager API ([[22-pinned-commits]]); `pcall(require, "lspconfig.manager")` fails soft if that architecture goes away.

Links: [[30-lsp-architecture]] · [[22-pinned-commits]] · [[index]]

Tags: [[tags#lsp|#lsp]] · [[tags#gotcha|#gotcha]]

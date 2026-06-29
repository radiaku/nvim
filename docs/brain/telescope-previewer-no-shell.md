# Telescope previewer — no external shell tools

The custom Telescope buffer previewer in `plugins/navigation/telescope.lua` (`no_preview_minified`) clips the preview of large/minified files. It must **not** spawn Unix executables like `head` or `echo`: those aren't standalone binaries on Windows (`echo` is a shell builtin), so libuv fails with **`head: Executable not found`** — surfaced as a `plenary/job.lua:108` error the moment you select such a file (e.g. via `<leader>fs`).

Fix in place: two pure-Lua helpers defined in the `config` function, used instead of `utils.job_maker({ "head"/"echo", ... })`:
- `preview_clipped(filepath, bufnr, byte_limit)` — reads first N bytes with `vim.loop.fs_open/fs_read` and sets buffer lines (replaces `head -c`).
- `set_preview_lines(bufnr, text)` — sets buffer text directly (replaces the `echo` calls in `preview.timeout_hook` / `filesize_hook`).

**Rule:** anything in this config that previews/inspects files must use Lua/`vim.loop` or guard the executable, never assume coreutils exist. This is a recurring cross-platform trap. → [[windows-pwsh]] · [[termux-detection]]

Note: `rg` (ripgrep) *is* assumed present (it's a stated requirement and used for `vimgrep_arguments`); the rule is about incidental Unix tools like `head`/`echo`/`cat`.

File: `lua/radia/plugins/navigation/telescope.lua`

Links: [[plugin-organization]] · [[windows-pwsh]] · [[verification]] · [[index]]

#plugins #platform

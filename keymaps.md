# Keymaps

This document summarizes the key mappings defined in this configuration. Modes are noted as `n` (normal), `i` (insert), `v` (visual), `c` (command), and `t` (terminal).

Notes
- `<leader>` refers to your configured leader key (commonly space). This config uses many `<leader>` mappings.
- Alt/Meta is shown as `<A-…>` or `<M-…>` depending on platform and terminal settings.

## Global Editing
- `i jk` — Exit insert mode.
- `c <C-j>` / `<C-k>` — Command-line completion down/up.
- `i <C-j>` / `<C-k>` — Insert-mode completion down/up.
- `i <S-Insert>` — Paste from clipboard.
- `i <A-P>` — Paste from clipboard.
- `n <leader>nh` — Clear search highlights.

## Terminal Mode
- `t <C-\>` — Enter normal mode.
- `t <C-t>` — Toggle terminal and enter normal mode.
- `t <Esc>` — Enter normal mode.
- `t <A-h/j/k/l>` — Move to window left/down/up/right.

## Windows & Splits
- `n <leader>sv` — Split window vertically.
- `n <leader>sh` — Split window horizontally.
- `n <leader>sx` — Close current split.
- `n <leader>co` — Close other splits (`:only`).
- `n <A-h/j/k/l>` — Focus window left/down/up/right.
- `n <M-,>` / `<M-.>` — Resize split left/right.
- `n <M-u>` / `<M-d>` — Resize split up/down.

## Buffers & Tabs
- `n <leader>bd` — Close current buffer.
- `n <leader>ba` — Close all buffers except current.
- `n <leader>bk` — Quit (force).
- `n <C-l>` — Next buffer (BufferLine).
- `n <C-h>` — Previous buffer (BufferLine).
- `n <leader>fu` — Find and manage buffers (custom Telescope picker).

## Files & Working Directory
- `n <leader>cd` — Change working directory to current file and show `pwd`.
- `n <leader>ee` — Neo-tree: toggle floating explorer.
- `n <leader>ef` — Neo-tree: toggle left explorer.

## Search & Telescope
- `n <leader>ff` — Find files (ivy, no preview).
- `n <leader>fh` — Find files including hidden, not ignored.
- `n <leader>fs` — Live grep in cwd (supports flags via `live_grep_args`).
- `n <leader>fx` — Live grep in cwd including hidden files (ignores `.git/`).
- `n <leader>fa` — List and pick buffers.
- `n <leader>fr` — Registers viewer (vertical layout).
- `n <leader>fm` — Keymaps viewer (vertical layout).
- `n <leader>fd` — LSP document symbols.
- `n <leader>fc` — Live grep in current buffer.
- `v <leader>fc` — Registers viewer (vertical layout).

## Folding
- `n zR` — Open all folds (ufo).
- `n zM` — Close all folds (ufo).

## Formatting
- `n/v <leader>rf` — Format file/selection (conform, LSP fallback).

## Diagnostics
- `n <leader>xx` — Trouble: toggle diagnostics view.
- `n gl` — Show line diagnostics.
- `n <leader>qf` — Open quickfix.
- `n <leader>cc` — Close quickfix.
- `n <leader>cf` — Clear quickfix list (custom command).

## LSP (buffer-local on attach)
- `n gr` — References.
- `n gd` — Definitions (Telescope).
- `n gi` — Implementations (Telescope).
- `n/v <leader>ca` — Code actions.
- `n <leader>rn` — Rename symbol.
- `n K` — Hover documentation.
- `n <leader>rs` — Restart LSP.

## Git
- `n <leader>lg` — Toggle Lazygit.
- `n <leader>ng` — Neogit (floating).

## Navigation & Marks
- `n t` — Hop pattern search.
- `n <leader>hm` — Harpoon menu (Telescope).
- `n <leader>ha` — Harpoon add file.
- `n <leader>hn` / `<leader>hp` — Harpoon next/prev.
- `n <leader>ml` — Marks list for current buffer (quickfix).

## Notes (Obsidian)
- `n <leader>so` — Search notes.
- `n <leader>sn` — New note.

## Database UI
- `n <leader>db` — Toggle DBUI.
- `n <leader>dc` — Add DB connection.

## Misc
- `n <M-0>` — Reset GUI font to JetBrainsMono Nerd Font 14.
- `n <leader>xs` — Source current file.
- `v <leader>xr` — Run selected Lua chunk.
- `n <C-t>` — Toggle terminal.

## Notes on Overlapping Mappings
- `<leader>fc` is defined multiple times; the effective normal-mode mapping is “Find string in current buffer”. Visual-mode `<leader>fc` opens the registers viewer.

## Related Files
- `lua/radia/keymaps/default.lua`
- `lua/radia/keymaps/custom.lua`
- `lua/radia/keymaps/custom_function.lua`
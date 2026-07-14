# Telescope find keymaps (`<leader>f*`)

The `<leader>f*` family in `lua/radia/keymaps/custom.lua` is the search surface of this config. The non-obvious part: the two grep maps use the **live_grep_args** Telescope extension and pre-fill the prompt with `-F ` (ripgrep `--fixed-strings`), so queries are treated as **literal text, not regex** by default. Type `foo.bar()` and it matches verbatim; delete the `-F` (or add flags like `-t lua`, `--hidden`) to get full ripgrep behavior inline.

| Map | What | Scope |
|-----|------|-------|
| `<leader>fs` | live_grep_args, prefilled `-F ` | cwd |
| `<leader>fx` | live_grep_args, prefilled `-F ` | nvim config (`stdpath("config")`) |
| `<leader>ff` | find_files (ivy, no previewer) | cwd |
| `<leader>fh` | find_files + `hidden=true no_ignore=true` | cwd |
| `<leader>fc` (n) | live_grep with `--fixed-strings`, current file only | buffer |
| `<leader>fb` | live_grep over open buffers | open buffers |
| `<leader>fa` | buffers picker | buffers |
| `<leader>fd` | lsp_document_symbols | buffer |
| `<leader>fr` / `<leader>fm` | registers / keymaps pickers | — |

## Prompt flags (live_grep_args)

The `fs`/`fx` prompt is passed to ripgrep as arguments, so any rg flag works inline. Quote the pattern when it contains spaces or when mixing with flags:

| Prompt | Effect |
|--------|--------|
| `-F foo.bar()` | literal search (the default prefill) |
| `"foo bar" -t lua` | pattern with spaces, only `*.lua` files |
| `"foo" -g "*.md"` / `-g "!dist/**"` | include / exclude by glob |
| `"foo" --hidden` | include hidden files |
| `"foo" --no-ignore` | include gitignored files |
| `"foo" -w` | whole-word match |
| `"foo" -i` / `-S` | case-insensitive / smart-case |
| `"foo" lua/radia/` | restrict to a path (trailing positional arg = path) |

Extension config (`plugins/navigation/telescope.lua`): `auto_quoting = true` — an unquoted prompt not starting with `-`/`"` is treated as one literal pattern; once it starts with a flag or quote, it's shell-split into rg args. Plugin-default prompt mappings are active (not overridden): `<C-k>` quotes the current prompt, `<C-i>` quotes it and appends ` --iglob `.

Gotchas:

- `<leader>fc` is defined **twice** in `custom.lua` (normal mode): first as `:Telescope neoclip` (line ~54), later as current-buffer grep (line ~76). The later definition wins, so neoclip is effectively unreachable via `fc` in normal mode; visual-mode `<leader>fc` is the registers picker.
- Selecting large/minified files from these pickers goes through the custom previewer — see [[24-telescope-previewer-no-shell]] for why it must not spawn `head`/`echo` on Windows.

Files: `lua/radia/keymaps/custom.lua` · `lua/radia/plugins/navigation/telescope.lua`

Links: [[40-keymaps]] · [[24-telescope-previewer-no-shell]]

Tags: [[tags#keymaps|#keymaps]] · [[tags#plugins|#plugins]] · [[tags#gotcha|#gotcha]]

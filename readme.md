Radia's Neovim configuration — fast, pragmatic, and organized.

See the **[Installer Index](installer/README.md)** for all platform setup guides, keymaps, extras, and build instructions.

**What you get**
- Plugins cleanly grouped by function: `ui`, `files`, `navigation`, `git`, `editing`, `diagnostics`, `language`, `terminal`, `session`, `tools`, `notes`, `lsp` (plus `disabled` for parked specs).
- Smart defaults and helpful keymaps for everyday workflows.
- Optional integrations like Lazygit, Obsidian, and Yazi.

**Quick Start**
- Put this repo at `~/.config/nvim`:
  ```sh
  git clone https://github.com/radiaku/nvim ~/.config/nvim
  ```
- Launch Neovim: `nvim`
- Open plugin UI and install: `:Lazy sync`
- Install Treesitter parsers: `:TSInstall`

**Requirements (short list)**
- Neovim 0.10.x+
- `git`, compiler toolchain (`gcc`/`clang`, `make`)
- `ripgrep` and `fd`
- Nerd Font (set in your terminal)
- Optional: Node, Python, Go, JDK, .NET, `lazygit`, `yazi`

**Themes**
- Set `_G.themesname` before plugin setup (e.g., `tokyonight`, `cyberdream`, `gruvbox`, `sonokai`).
- Colorscheme application lives in `lua/radia/themes.lua`.

**Learn the Keys**
- Read the [Keymaps](installer/05-neovim-keymaps.md) for a human-friendly overview.
- In Neovim: `:Telescope keymaps` or `<leader>fm`.

**Common Commands**
- `:Lazy` — manage plugins
- `:Mason` — install LSPs/formatters
- `:TSInstall` — Treesitter parsers
- `:checkhealth` — environment checks

**Structure**
- `lua/radia/plugins/*` — grouped plugin specs
- `lua/radia/keymaps/*` — keymap files
- `lua/radia/core/init.lua` — plugin loader (lazy.nvim)

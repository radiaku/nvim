Radia’s Neovim configuration — fast, pragmatic, and organized.

This README is a friendly overview. For full setup details and all key mappings, see:
- [Fonts: Nerd Font Install](installer/fonts.md)
- [Installer Guide](installer/setup.md)
- [Keymaps](installer/keymaps.md)
- [Git Profile Setup](installer/git.md)
- [Rust & Cargo](installer/cargo.md)

If you want builder for neovim 0.10.4, check [build-linux](installer/build-linux.md)
or [build-windows](installer/build-windows.md)
or [build-termux](installer/build-termux.md)


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
- Install Treesitter parsers: `:TSUpdate`

**Requirements (short list)**
- Neovim 0.10.x
- `git`, compiler toolchain (`gcc`/`clang`, `make`)
- `ripgrep` and `fd`
- Nerd Font (set in your terminal)
- Optional: Node, Python, Go, JDK, .NET, `lazygit`, `yazi`

See the [Installer Guide](installer/setup.md) for macOS/Linux commands and details.

**Themes**
- Set `_G.themesname` before plugin setup (e.g., `tokyonight`, `cyberdream`, `gruvbox`, `sonokai`).
- Colorscheme application lives in `lua/radia/themes.lua`.

**Learn the Keys**
- Read the [Keymaps](installer/keymaps.md) for a human-friendly overview.
- In Neovim: `:Telescope keymaps` or `<leader>fm`.

**Common Commands**
- `:Lazy` — manage plugins
- `:Mason` — install LSPs/formatters
- `:TSUpdate` — Treesitter
- `:CheckHealth` — environment checks

**Structure**
- `lua/radia/plugins/*` — grouped plugin specs
- `lua/radia/keymaps/*` — keymap files
- `lua/radia/lazy.lua` — plugin loader
 
**Windows Notes**
- If using Scoop/MSYS2, ensure paths are set and tools installed.
- For FZF, verify search utilities exist and are detected (`fd`, `rg`).

Enjoy, and tweak freely. If anything feels rough, check `installer/setup.md` first — it covers most gotchas.


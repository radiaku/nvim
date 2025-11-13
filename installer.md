# Installer Guide

This guide outlines requirements, installation, and post-install steps for this Neovim configuration.

If you're on  Windows , see the dedicated guide: [Installer (Windows)](installerwindows.md).


If you're on Android using Termux, see the dedicated guide: [Installer (Termux)](installertermux.md).

## Quick Install (copy-paste)
- Clone directly to your Neovim config path:
```bash
git clone https://github.com/radiaku/nvim ~/.config/nvim
```
- Or symlink this repo from your workspace (run from this repo’s root):
  - `ln -s "$(pwd)" ~/.config/nvim`
- Launch Neovim and install plugins:
  - `nvim` then inside Neovim run `:Lazy sync` and `:TSUpdate`.
- Update later:
  - `git -C ~/.config/nvim pull`

## Requirements
- Neovim `>= 0.9` (0.10 recommended).
- `git` in `PATH`.
- Build tools for native plugins and Treesitter: `gcc`/`clang`, `make`.
- Search tools:
  - `ripgrep` (`rg`) — required for Telescope grep.
  - `fd` — recommended for fast file search.
- Nerd Font installed and selected in your terminal (e.g., `JetBrainsMono Nerd Font`).
- Optional, based on languages/tools you use:
  - Node.js (`node`, `npm`/`pnpm`/`yarn`) for JS/TS tooling.
  - Python 3 (`python3`, `pip`), for Python LSP tooling.
  - Go toolchain (`go`).
  - JDK (17+) and `maven`/`gradle` for Java.
  - .NET SDK for C#.
  - `lazygit` (for `:LazyGit`).
  - `yazi` file manager (if using the Yazi integration).

### macOS Quick Setup
- Install packages with Homebrew:
  - `brew install neovim git ripgrep fd node go python lazygit yazi`
  - Ensure a compiler is present: `xcode-select --install` (or `brew install llvm`).

### Linux Quick Setup
- Debian/Ubuntu:
  - `sudo apt update && sudo apt install -y neovim git ripgrep fd-find build-essential nodejs npm python3 python3-pip fzf `
  - Symlink `fd`: `sudo ln -s $(command -v fdfind) /usr/local/bin/fd` (if it installs as `fdfind`).
- Arch:
  - `sudo pacman -S neovim git ripgrep fd nodejs npm python go base-devel fzf lua`

## Installation
1. Place the config in your Neovim config dir:
   - Clone or symlink to `~/.config/nvim`.
   - Example symlink from your workspace:
     - `ln -s /Users/mac/Dev/personal/nvim ~/.config/nvim`
2. Launch Neovim:
   - `nvim`
   - The config bootstraps `lazy.nvim` automatically (cloned to `stdpath('data')/lazy/lazy.nvim`).
3. Install plugins:
   - Run `:Lazy sync` (or `:Lazy install`), then restart Neovim.

## Theme Selection
- This config uses `_G.themesname` to select the colorscheme.
- Set it before plugin setup, e.g. in `init.lua`:
  - `lua _G.themesname = "tokyonight"`
- Available themes included: `cyberdream`, `tokyonight`, `gruvbox`, `sonokai`.
- Colorscheme is applied by `lua/radia/themes.lua`.

## Language Servers & Tools
- Open Mason UI: `:Mason`.
- Install servers/tools as needed. This config auto-detects availability and ensures common servers:
  - Lua: `lua_ls`
  - JS/TS: `vtsls`, `cssls`, `html`, `emmet_ls`, `tailwindcss`, `jsonls`
  - Python: `basedpyright`
  - Go: `gopls`
  - Formatters/Linters: `stylua`, `prettier`, `eslint_d`, `black`, `pylint`
- Treesitter parsers:
  - `:TSUpdate` to install/update parsers.

## Project Layout
- Plugin specs grouped under:
  - `lua/radia/plugins/ui`, `files`, `navigation`, `git`, `editing`, `diagnostics`, `language`, `terminal`, `session`, `tools`, `notes`, `lsp`.
- Keymaps:
  - Files in `lua/radia/keymaps/` and summary in `keymaps.md`.
- Lazy setup:
  - `lua/radia/lazy.lua` imports each group explicitly.

## Common Commands
- `:Lazy` — plugin manager UI.
- `:Mason` — LSP/DAP/formatters installer.
- `:TSUpdate` — install/update Treesitter parsers.
- `:CheckHealth` — verify environment.

## Optional Integrations
- Lazygit: `brew install lazygit` or install via your package manager; open with `:LazyGit`.
- Yazi: `brew install yazi`; enable plugin if desired.
- Obsidian: set vault path in `lua/radia/plugins/notes/obsidian.lua`.

## Troubleshooting
- Build errors on install:
  - Ensure compiler toolchain is installed (`gcc`/`clang`, `make`).
- Icons not showing:
  - Install a Nerd Font and select it in your terminal profile.
- Colors off:
  - Ensure `termguicolors` is enabled (it is in `core/settings.lua`).
- Slow startup or plugin issues:
  - Run `:Lazy clean`, `:Lazy sync`, then restart.
  - Check logs: `:Lazy log`.

## Uninstall / Reset
- Remove config dir: `rm -rf ~/.config/nvim`.
- Remove Neovim data (plugins, cache):
  - Show path: `:echo stdpath('data')`.
  - On macOS: `~/Library/Application Support/nvim`.
  - On Linux: `~/.local/share/nvim`.
  - Delete if you want a clean reinstall.
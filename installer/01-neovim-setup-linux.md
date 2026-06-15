# Installer Guide

> **Step 1** · Tags: #linux #core | [Index](README.md)

This guide outlines requirements, installation, and post-install steps for this Neovim configuration.

If you're on macOS, see the dedicated guide: [Installer (macOS)](01-neovim-setup-macos.md).

If you're on Windows, see the dedicated guide: [Installer (Windows)](01-neovim-setup-windows.md).


If you're on Android using Termux, see the dedicated guide: [Installer (Termux)](01-neovim-setup-termux.md).

## Setup Order

Install the base environment first. Clone the Neovim config only after `git`, Neovim, compilers, and search tools are installed.

## Requirements
- Neovim `0.10.4` is the target version for this branch/config.
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
  - JDK (17+) and `maven`/`gradle` for Java. Note: Kotlin Language Server requires JDK 17; newer JDKs (e.g., 25) can crash.
  - .NET SDK for C#.
  - `lazygit` (for `:LazyGit`).
  - `yazi` file manager (if using the Yazi integration).

### Linux Quick Setup
- Debian/Ubuntu:
  - ```sudo apt update && sudo apt install -y neovim git ripgrep fd-find build-essential nodejs npm python3 python3-pip fzf zoxide lazygit tmux tree```
  - Symlink `fd` only if needed:
    ```bash
    if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1 && [ ! -e /usr/local/bin/fd ]; then
      sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd
    fi
    ```
- Arch:
  - `sudo pacman -S neovim git ripgrep fd nodejs npm python go base-devel fzf lua zoxide lazygit tmux tree`

## Clone Config

> [!IMPORTANT]
> Back up or merge existing files first. Do not overwrite an existing Neovim config or shell profile unless you are sure.

Check for an existing config and clone only when the target directory is free:

```bash
if [ -e ~/.config/nvim ]; then
  echo "~/.config/nvim already exists. Back it up or update it with: git -C ~/.config/nvim pull"
else
  git clone https://github.com/radiaku/nvim ~/.config/nvim
fi
```

If you want this repo's Bash settings, back up your current shell config before copying:

```bash
if [ -e ~/.bashrc ]; then
  cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d-%H%M%S)
fi
cp ~/.config/nvim/.bashrc ~/.bashrc
source ~/.bashrc
```

Or symlink this repo from your workspace after installing the base tools:

```bash
ln -s "$(pwd)" ~/.config/nvim
```

## First Launch

```bash
nvim
```

Inside Neovim, run `:Lazy sync`, `:TSUpdate`, and `:checkhealth`.

Update later:

```bash
git -C ~/.config/nvim pull
```


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
  - Files in `lua/radia/keymaps/` and summary in `05-neovim-keymaps.md`.
- Lazy setup:
  - `lua/radia/lazy.lua` imports each group explicitly.

## Common Commands
- `:Lazy` — plugin manager UI.
- `:Mason` — LSP/DAP/formatters installer.
- `:TSUpdate` — install/update Treesitter parsers.
- `:checkhealth` — verify environment.

## Optional Integrations
- Lazygit: install via your Linux package manager; open with `:LazyGit`.
- Yazi: install via your Linux package manager; enable plugin if desired.
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
- Back up before removing the config directory:
  ```bash
  mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)
  ```
  Delete the backup later only after confirming you no longer need local customizations.
- Remove Neovim data (plugins, cache):
  - Show path: `:echo stdpath('data')`.
  - On macOS: `~/Library/Application Support/nvim`.
  - On Linux: `~/.local/share/nvim`.
  - Delete if you want a clean reinstall.
- Kotlin LS crashes with `IllegalArgumentException: 25.0.1`:
  - You are running a Java 25 JDK that KLS doesn’t parse correctly.
  - Install JDK 17 and set `JAVA_HOME` as above; restart Neovim.
  - This config auto-uses JDK 17 for KLS when incompatible Java is detected on macOS.

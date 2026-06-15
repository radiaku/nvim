# Installer Index

> **Tags:** #index

## Version baseline

- Target Neovim version for this branch/config: `0.10.4`.
- Plugin commits are locked for this Neovim version. Do not upgrade this guide to later Neovim versions unless the lock set is updated.
- Newer Neovim work is tracked separately on `branch-12`.

## Before you run commands

- Verify you are using the guide for your platform and shell.
- Install the base environment before cloning the config: package manager, Git, Neovim `0.10.4`, build tools, `ripgrep`, `fd`, and required language runtimes.
- Check whether a Neovim config already exists and back it up before cloning:
  - Linux/macOS/Termux: `test -e ~/.config/nvim && mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)`
  - PowerShell: `if (Test-Path $env:LOCALAPPDATA\nvim) { Rename-Item $env:LOCALAPPDATA\nvim "nvim.backup.$(Get-Date -Format yyyyMMdd-HHmmss)" }`
- Verify package-manager availability before installing packages.
- Check existing tools with `nvim --version`, `git --version`, `rg --version`, and `fd --version` where available.

| Doc | Tags | Description |
|-----|------|-------------|
| [01-neovim-setup-linux.md](01-neovim-setup-linux.md) | `#linux` `#macos` `#core` | Linux/macOS setup |
| [01-neovim-setup-windows.md](01-neovim-setup-windows.md) | `#windows` `#core` | Windows landing page |
| [01-neovim-setup-windows-winget.md](01-neovim-setup-windows-winget.md) | `#windows` `#winget` `#core` | Windows via winget |
| [01-neovim-setup-windows-scoop.md](01-neovim-setup-windows-scoop.md) | `#windows` `#scoop` `#core` | Windows via Scoop |
| [01-neovim-setup-termux.md](01-neovim-setup-termux.md) | `#termux` `#android` `#core` | Android/Termux setup |
| [04-rust-cargo.md](04-rust-cargo.md) | `#all` `#optional` | Rust & Cargo install |
| [02-nerd-fonts.md](02-nerd-fonts.md) | `#all` `#optional` | Nerd Font install |
| [03-git-profile.md](03-git-profile.md) | `#all` `#optional` | Git profile setup |
| [05-neovim-keymaps.md](05-neovim-keymaps.md) | `#all` `#reference` | Keybindings reference |
| [06-neovim-build-linux.md](06-neovim-build-linux.md) | `#linux` `#build` | Build Neovim from source (Linux) |
| [06-neovim-build-windows.md](06-neovim-build-windows.md) | `#windows` `#build` | Build Neovim from source (Windows) |
| [06-neovim-build-termux.md](06-neovim-build-termux.md) | `#termux` `#build` | Build Neovim from source (Termux) |

## Quick Paths

- **New user on Windows?** → [Scoop](01-neovim-setup-windows-scoop.md) (recommended) or [winget](01-neovim-setup-windows-winget.md)
- **New user on Linux/macOS?** → [Setup Guide](01-neovim-setup-linux.md)
- **Android?** → [Termux Guide](01-neovim-setup-termux.md)
- **Already set up?** → [Keymaps](05-neovim-keymaps.md)
- **Need a Nerd Font?** → [Fonts](02-nerd-fonts.md)
- **Want Rust tools?** → [Cargo](04-rust-cargo.md)
- **Building Neovim from source?** → [Linux](06-neovim-build-linux.md) | [Windows](06-neovim-build-windows.md) | [Termux](06-neovim-build-termux.md)

## New User Step-by-Step

| Step | What | Link |
|:----:|------|------|
| 1 | Set up your platform | [Linux/macOS](01-neovim-setup-linux.md) · [Windows](01-neovim-setup-windows.md) · [Termux](01-neovim-setup-termux.md) |
| 2 | Install a Nerd Font | [nerd-fonts](02-nerd-fonts.md) |
| 3 | Configure Git | [git-profile](03-git-profile.md) |
| 4 | (Optional) Install Rust/Cargo | [rust-cargo](04-rust-cargo.md) |
| 5 | Learn keymaps | [neovim-keymaps](05-neovim-keymaps.md) |
| 6 | (Advanced) Build Neovim from source | [Linux](06-neovim-build-linux.md) · [Windows](06-neovim-build-windows.md) · [Termux](06-neovim-build-termux.md) |

## macOS build note

This installer includes macOS setup commands, but source-build instructions are currently documented for Linux, Windows, and Termux only.

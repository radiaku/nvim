# Windows Installer Guide

> **Step 1** · Tags: #windows #core | [Index](README.md)

Two package manager options — pick one:

- **[Winget](01-neovim-setup-windows-winget.md)** — built into Windows 10/11, simple CLI
- **[Scoop](01-neovim-setup-windows-scoop.md)** — more packages, per-user installs, version pinning

## Shared Requirements

- PowerShell (recommended)
- Git
- Neovim `0.11+` recommended
- For native plugins: `cmake`, `ninja`, and a C compiler (`clang` via LLVM or VS Build Tools)
- For Telescope: `ripgrep` (`rg`) and `fd`

## Quick Clone

```powershell
git clone https://github.com/radiaku/nvim $env:LOCALAPPDATA\nvim
```

## Post-Install

Once tools are set up, open Neovim and run:

```vim
:Lazy sync
:TSInstall
:checkhealth
```

See the specific guide (winget or Scoop) for the full install commands, language server setup, and PATH configuration.

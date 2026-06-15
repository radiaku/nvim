# Windows Installer Guide

> **Step 1** · Tags: #windows #core | [Index](README.md)

Two package manager options — pick one:

- **[Winget](01-neovim-setup-windows-winget.md)** — built into Windows 10/11, simple CLI
- **[Scoop](01-neovim-setup-windows-scoop.md)** — more packages, per-user installs, version pinning

## Setup Order

Install the base environment first. Clone the Neovim config only after `git`, Neovim, build tools, and search tools are installed.

## Shared Requirements

- PowerShell (recommended)
- Git
- Neovim `0.10.4` is the target version for this branch/config
- For native plugins: `cmake`, `ninja`, and a C compiler (`clang` via LLVM or VS Build Tools)
- For Telescope: `ripgrep` (`rg`) and `fd`

## Follow a Full Install Guide First

Complete one of these guides before cloning the config:

- [Winget setup](01-neovim-setup-windows-winget.md)
- [Scoop setup](01-neovim-setup-windows-scoop.md)

Those guides install Neovim, Git, build tools, `ripgrep`, `fd`, language runtimes, and PATH setup.

## Clone Config

After the tools are installed and visible in PATH, back up or rename an existing Neovim config before cloning:

```powershell
if (Test-Path $env:LOCALAPPDATA\nvim) {
  Write-Host "$env:LOCALAPPDATA\nvim already exists. Back it up or update it with: git -C $env:LOCALAPPDATA\nvim pull"
} else {
  git clone https://github.com/radiaku/nvim $env:LOCALAPPDATA\nvim
}
```

## Post-Install

Once tools are set up and the config is cloned, open Neovim and run:

```vim
:Lazy sync
:TSUpdate
:checkhealth
```

See the specific guide (winget or Scoop) for the full install commands, language server setup, and PATH configuration.

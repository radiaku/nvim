# macOS Installer Guide

> **Step 1** · Tags: #macos #homebrew #core | [Index](README.md)

This guide sets up the base macOS environment first, then clones this Neovim config.

## Setup Order

Install Homebrew and the base environment first. Clone the Neovim config only after `git`, Neovim `0.10.4`, build tools, search tools, and language runtimes are installed.

## Requirements

- macOS with a supported shell (`zsh` or `bash`).
- Homebrew installed and available in PATH.
- Neovim `0.10.4` is the target version for this branch/config.
- Xcode Command Line Tools for compilers and `make`.
- `ripgrep` (`rg`) and `fd` for Telescope.
- Nerd Font installed and selected in your terminal.

## Install Homebrew

If Homebrew is not installed yet, install it from the official Homebrew instructions, then restart your shell and verify:

```bash
brew --version
```

## Install Base Tools

Use Homebrew for dependencies first:

```bash
xcode-select --install
brew update
brew install git ripgrep fd node go python lazygit yazi tmux tree fzf lua cmake ninja
```

## Install Neovim 0.10.4

This branch targets Neovim `0.10.4`. If your Homebrew tap currently provides `0.10.4`, install and verify it:

```bash
brew install neovim
nvim --version
```

If Homebrew installs a newer Neovim, do not treat that as the target for this branch. Use your pinned/source build method for `0.10.4`, or use `branch-12` for newer Neovim work.

Optional compiler/toolchain package if native plugin builds need newer LLVM:

```bash
brew install llvm
```

## Install Java 17 for Kotlin LS

Kotlin Language Server expects JDK 17; newer JDKs can crash.

```bash
brew install openjdk@17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"
```

Add the exports to your shell profile if you use Kotlin regularly.

## Verify Tools

```bash
nvim --version
git --version
rg --version
fd --version
node --version
python3 --version
go version
```

## Clone Config

> [!IMPORTANT]
> Back up or merge existing files first. Do not overwrite an existing Neovim config or shell profile unless you are sure.

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

## First Launch

```bash
nvim
```

Inside Neovim, run:

```vim
:Lazy sync
:TSUpdate
:checkhealth
```

## Optional Integrations

```bash
brew install lazygit yazi
```

- Lazygit opens with `:LazyGit`.
- Yazi integration works when `yazi` is available in PATH.

## Update Later

```bash
git -C ~/.config/nvim pull
brew update && brew upgrade
```

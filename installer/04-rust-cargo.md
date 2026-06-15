# Rust & Cargo Installer

> **Step 4** · Tags: #all #optional | [Index](README.md)

The standard way to install Rust on any platform is `rustup` — the official Rust toolchain installer.

## Quick Install

**Windows (PowerShell):**

```powershell
irm https://rustup.rs | iex
```

**Windows (Scoop):**

```powershell
scoop install rustup
```

**Linux / macOS / Termux:**

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

After install, reload your shell or run:

**Windows:**

```powershell
$env:PATH += ";$env:USERPROFILE\.cargo\bin"
```

**Linux/Termux/WSL:**

```sh
source "$HOME/.cargo/env"
```

## Verify

```sh
rustc --version
cargo --version
```

## Why This Config Needs It

- **stylua** — Lua formatter, install via `cargo install stylua --locked` (used by conform.nvim and none-ls)
- **fd-find** — alternative to `fd` for Telescope, via `cargo install fd-find`
- **ripgrep** — alternative to `rg`, via `cargo install ripgrep`

If you already installed these tools via Scoop, winget, or your system package manager, Cargo is not required — skip it.

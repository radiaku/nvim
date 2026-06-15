# 📱 Neovim on Termux (Android)

> **Step 1** · Tags: #termux #android #core | [Index](README.md)

> ⚡ A full-featured Neovim + LSP + Telescope setup that works directly inside Termux.

[![Neovim](https://img.shields.io/badge/Neovim-0.10.4-green?logo=neovim)](https://neovim.io)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Termux-blue?logo=android)](https://termux.dev)
[![radiaku/nvim](https://img.shields.io/badge/GitHub-radiaku%2Fnvim-lightgrey?logo=github)](https://github.com/radiaku/nvim)

---

## 🧩 Table of Contents
- [1. Prerequisites](#1-prerequisites)
- [2. Install Base Packages](#2-install-base-packages)
- [3. Install Rust & Cargo](#3-install-rust--cargo)
- [4. Clone Config](#4-clone-config)
- [5. Build Telescope Native](#5-build-telescope-native)
- [6. LSPs on Termux](#6-lsps-on-termux)
- [7. Formatters & Linters](#7-formatters--linters)
- [8. Configure PATH in Neovim](#8-configure-path-in-neovim)
- [9. Verify Installation](#9-verify-installation)
- [💡 Extra Tips](#-extra-tips)

---

## 1️⃣ Prerequisites
> Termux 0.118+ (from F-Droid or GitHub), and a stable Internet connection.

```bash
pkg update -y && pkg upgrade -y
```

---

## 2️⃣ Install Everything (one place)

```bash
pkg update -y && pkg upgrade -y
pkg install -y neovim git curl wget ca-certificates openssl-tool unzip tar nodejs python golang openjdk-21 rust clang make cmake ripgrep fd lua-language-server fzf jq bat tree tmux zoxide termux-api lazygit yazi ffmpeg p7zip imagemagick
```

```bash
# Python formatters/linters
pip install --user black pylint
```

```bash
# Lua formatter
cargo install stylua --locked
```

```bash
# Go LSP (Android-safe, installed directly to Termux's bin)
export GOPATH="$HOME/.local/share/go"
export GOBIN="$PREFIX/bin"
mkdir -p "$GOBIN" "$GOPATH"
CGO_ENABLED=0 go install golang.org/x/tools/gopls@latest
```

```bash
npm install -g basedpyright
```

```bash
# Ensure user-installed tools are on PATH if your shell cannot find them
# echo 'export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"' >> ~/.bashrc
# source ~/.bashrc
```

This consolidates all installs up front and avoids mixing `pkg` with `apt` unless you have a specific Termux repo reason.

---

## 3️⃣ Install Rust & Cargo

Rust and Cargo are installed above. Check versions:

```bash
rustc --version
cargo --version
```

---

## 4️⃣ Clone Config

> [!IMPORTANT]
> Back up or merge existing files first. Do not overwrite an existing Neovim config or shell profile unless you are sure.

```bash
if [ -e ~/.config/nvim ]; then
  echo "~/.config/nvim already exists. Back it up or update it with: git -C ~/.config/nvim pull"
else
  git clone https://github.com/radiaku/nvim ~/.config/nvim
fi
```

```bash
if [ -e ~/.bashrc ]; then
  cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d-%H%M%S)
fi
cp ~/.config/nvim/.bashrc ~/.bashrc
source ~/.bashrc
```

```bash
nvim
```

Inside Neovim, run `:Lazy sync`, `:TSUpdate`, and `:checkhealth`.

Lazy.nvim will install all dependencies automatically.

---

## 5️⃣ Build Telescope Native

This is now automatic. On Termux, the config builds with `CC=clang` and falls back to CMake if `make` fails.

If you still see build errors, ensure `clang`, `make`, and `cmake` are installed (already included in base packages).

---

## 6️⃣ LSPs on Termux

Lua (`lua-language-server`) and Go (`gopls`) are installed above. Use Mason for Node-based servers.

### 🟦 Go: gopls
`gopls` is installed in section 2 with `CGO_ENABLED=0` and `GOBIN="$PREFIX/bin"` so it works reliably on Android/Termux.

<!-- Java/JDTLS intentionally unsupported on Termux in this config. -->

Mason-friendly servers (inside Neovim):
```
:Mason
```
- `vtsls`, `cssls`, `html`, `emmet_ls`, `tailwindcss`, `jsonls`, `bash-language-server`
- Python: `basedpyright` (requires Node)

Verify:
```
:checkhealth
```

---

## 7️⃣ Formatters & Linters

Installed above. Check versions:

```bash
stylua --version
black --version
pylint --version
```

---

## 8️⃣ Configure PATH in Neovim

```lua
vim.env.PATH = table.concat({
  vim.env.HOME .. "/.local/bin",
  vim.env.HOME .. "/.cargo/bin",
  vim.env.PATH,
}, ":")
```

---

## 9️⃣ Verify Installation

Inside Neovim:
```
:checkhealth
```

You should see ✅ for:
- `telescope.nvim`
- `lua-language-server`
- `stylua`
- `black`
- `pylint`

---


## 💡 Extra Tips

- Use `fd` + `ripgrep` for blazing-fast Telescope searches  
- To avoid startup crash if `fzf` build fails:
  ```lua
  pcall(require("telescope").load_extension, "fzf")
  ```
- Clipboard sync with tmux (OSC52): tmux is already installed above.

### 📋 Clipboard with Termux:API
- Install the companion app from F-Droid: `Termux:API`.
- Install the CLI package (already in section 2): `pkg install termux-api`.
- Test it works:
  ```bash
  termux-clipboard-set "hello"
  termux-clipboard-get
  ```
- Neovim uses these automatically in this config. If you prefer faster copies inside tmux, use the provided OSC52 mapping: visually select and press `<leader>y`.
- For persistent environment:
  ```bash
  source ~/.bashrc
  ```

- Fast directory jumping (zoxide): zoxide and fzf are installed above.
  - bash: `echo 'eval "$(zoxide init bash)"' >> ~/.bashrc && source ~/.bashrc`
  - zsh: `echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc`
  - Use `z <keyword>` to jump; `zi` opens an interactive fzf picker.
  - Works inside tmux automatically since it loads your shell configs.

---

## 🚑 Troubleshooting (Termux-specific)

Some Mason packages don’t ship Android builds. Prefer system installs or the consolidated commands in section 2.

<!-- jdtls removed from Termux docs to prevent confusion and unwanted installs. -->

### go.nvim tool installs fail with `runtime/cgo` or `aarch64-linux-android-clang`
Use CGO-free installs as in section 2. This config also auto-disables CGO during go.nvim tool installs when Termux is detected.

### lua-language-server “current platform is unsupported”
Use the Termux package included in the base install (section 2).

### stylua “current platform is unsupported”
Install via Cargo as in section 2.

After installing these system binaries, Neovim will prefer tools found on `PATH` even if Mason couldn’t install them.

---

✨ **Enjoy your fully working Neovim setup on Termux!**  
Maintained by [@radiaku](https://github.com/radiaku)
### 🧠 Language Servers (Global Installs)
- Node-based servers (requires `nodejs`):
  - `npm i -g vtsls typescript`
  - `npm i -g vscode-langservers-extracted`
  - `npm i -g @tailwindcss/language-server`
  - `npm i -g intelephense`
  - `npm i -g basedpyright`
- Go:
  - `pkg install gopls` or `go install golang.org/x/tools/gopls@latest`
- Optional C/C++:
  - `pkg install clangd`

Note: On Termux, global `npm` installs place binaries in `$PREFIX/bin`. Ensure `$PREFIX/bin` is on `PATH` (tmux.conf already propagates it).

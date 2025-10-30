# 📱 Neovim on Termux (Android)
> ⚡ A full-featured Neovim + LSP + Telescope setup that works directly inside Termux.

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-green?logo=neovim)](https://neovim.io)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Termux-blue?logo=android)](https://termux.dev)
[![radiaku/nvim](https://img.shields.io/badge/GitHub-radiaku%2Fnvim-lightgrey?logo=github)](https://github.com/radiaku/nvim)

---

## 🧩 Table of Contents
- [1. Prerequisites](#1-prerequisites)
- [2. Install Base Packages](#2-install-base-packages)
- [3. Install Rust & Cargo](#3-install-rust--cargo)
- [4. Clone Config](#4-clone-config)
- [5. Build Telescope Native](#5-build-telescope-native)
- [6. LSPs via Mason](#6-lsps-via-mason)
- [7. Formatters & Linters](#7-formatters--linters)
- [8. Configure PATH in Neovim](#8-configure-path-in-neovim)
- [9. Verify Installation](#9-verify-installation)
- [10. Quick Summary](#10-quick-summary)
- [💡 Extra Tips](#-extra-tips)

---

## 1️⃣ Prerequisites
> Termux 0.118+ (from F-Droid or GitHub), and a stable Internet connection.

```bash
pkg update -y && pkg upgrade -y
```

---

## 2️⃣ Install Base Packages
<details>
<summary>Click to expand</summary>

```bash
pkg install -y git curl wget unzip tar neovim nodejs python clang make cmake ripgrep fd
```

Optional extras for better experience:
```bash
pkg install -y fzf lua-lsp jq bat tree
```
</details>

---

## 3️⃣ Install Rust & Cargo
<details>
<summary>Click to expand</summary>

Termux’s `rust` package already includes Cargo.

```bash
pkg install -y rust
```

Then make sure Cargo binaries are visible:
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.cargo/bin:$PATH"
```

Check versions:
```bash
rustc --version
cargo --version
```
</details>

---

## 4️⃣ Clone Config
<details>
<summary>Click to expand</summary>

```bash
git clone https://github.com/radiaku/nvim ~/.config/nvim
nvim
```

Lazy.nvim will install all dependencies automatically.
</details>

---

## 5️⃣ Build Telescope Native
<details>
<summary>Click to expand</summary>

```bash
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make clean && make
```

If `make` fails:
```bash
pkg install -y clang make cmake
```
</details>

---

## 6️⃣ LSPs via Mason
<details>
<summary>Click to expand</summary>

Inside Neovim:
```
:Mason
```

Install servers you need:
- `lua-language-server`
- `pyright` or `pylsp`
- (optional) `bash-language-server`, `json-lsp`, etc.

If `lua-language-server` build fails:
```bash
cd ~/.local/share/nvim/mason/packages/lua-language-server
./install.sh || ./3rd/luamake/luamake rebuild
```
</details>

---

## 7️⃣ Formatters & Linters
<details>
<summary>Click to expand</summary>

Some binaries (like `stylua`, `black`, `pylint`) aren’t built for Android,
so install them manually:

### 🐍 Python tools
```bash
pip install --user black pylint
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

### 🌙 Lua (via Cargo)
```bash
cargo install stylua --locked
```

Check:
```bash
stylua --version
black --version
pylint --version
```
</details>

---

## 8️⃣ Configure PATH in Neovim
<details>
<summary>Click to expand</summary>

If Neovim can’t find your binaries, extend PATH in Lua:

```lua
vim.env.PATH = table.concat({
  vim.env.HOME .. "/.local/bin",
  vim.env.HOME .. "/.cargo/bin",
  vim.env.PATH,
}, ":")
```
</details>

---

## 9️⃣ Verify Installation
<details>
<summary>Click to expand</summary>

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
</details>

---

## 🔟 Quick Summary
```bash
pkg install -y neovim git nodejs python rust clang make cmake ripgrep fd
git clone https://github.com/radiaku/nvim ~/.config/nvim
cargo install stylua --locked
pip install --user black pylint
nvim
```

---

## 💡 Extra Tips

- Use `fd` + `ripgrep` for blazing-fast Telescope searches  
- To avoid startup crash if `fzf` build fails:
  ```lua
  pcall(require("telescope").load_extension, "fzf")
  ```
- Clipboard sync with tmux (OSC52):
  ```bash
  pkg install -y tmux
  ```
- For persistent environment:
  ```bash
  source ~/.bashrc
  ```

---

✨ **Enjoy your fully working Neovim setup on Termux!**  
Maintained by [@radiaku](https://github.com/radiaku)

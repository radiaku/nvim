# Windows Installer Guide — winget

This guide sets up Neovim and language servers on Windows using `winget`. It covers native build tools, global installs for Node-based LSPs, Go `gopls`, and optional `clangd` for C/C++.

If you prefer **Scoop**, see [Scoop Guide](setup-windows-scoop.md).

## Prerequisites

- PowerShell (recommended)
- Git (needed for many tools and plugin managers)
- Neovim `0.11+` is recommended for the current plugin set
- For native plugins on Windows: `cmake`, `ninja`, and a C compiler such as `clang` (via LLVM) or Visual Studio Build Tools
- For Telescope pickers: `ripgrep` (`rg`) and `fd`

## Install Core Tools

Search packages if IDs change:

```
winget search neovim
winget search nodejs
winget search python
winget search golang
winget search llvm
winget search cmake
winget search ninja
winget search git
```

Install core tools:

```
winget install --id Neovim.Neovim -e
winget install --id Git.Git -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Python.Python.3.12 -e
winget install --id GoLang.Go -e
winget install --id Kitware.CMake -e
winget install --id Ninja-build.Ninja -e
winget install --id LLVM.LLVM -e   # provides clang/clangd
winget install --id BurntSushi.ripgrep.MSVC -e
winget install --id sharkdp.fd -e
```

Optional shell extras:

```
winget install JanDeDobbeleer.OhMyPosh --source winget
winget install --exact --id junegunn.fzf
```

## Native Plugin Notes

This config uses `telescope-fzf-native.nvim`, which needs build tools on Windows.

- `telescope.nvim` itself is installed by `lazy.nvim`
- the optional native `fzf` extension needs `cmake`, `ninja`, and a compiler
- `rg` and `fd` should also be installed so Telescope file and grep pickers work well

If Telescope installs but the `fzf` extension is still missing, build it manually:

```powershell
cd $env:LOCALAPPDATA\nvim-data\lazy\telescope-fzf-native.nvim
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cmake --install build --prefix build
```

After that, restart Neovim and run:

```vim
:checkhealth
:Lazy sync
```

PowerShell extras:

```powershell
Install-Module -Name PSFzfHistory
nvim $PROFILE
```

Profile examples:
```
https://github.com/radiaku/vscodepublicconfig
```

## Clone Config

Place this repo in the Windows Neovim config directory (`%LOCALAPPDATA%\nvim`):

- PowerShell:

```powershell
git clone https://github.com/radiaku/nvim $env:LOCALAPPDATA\nvim
```

- CMD:

```cmd
git clone https://github.com/radiaku/nvim %LOCALAPPDATA%\nvim
```

- WSL/Linux (if using Neovim inside WSL):

```sh
git clone https://github.com/radiaku/nvim ~/.config/nvim
```

## Language Servers (Global Installs)

These installs provide language servers outside of Neovim package managers (e.g., Mason). Your Neovim config can use them directly when available.

### Node-based LSPs (via npm)

```
npm i -g vtsls typescript vscode-langservers-extracted @tailwindcss/language-server intelephense basedpyright
```

PATH for npm globals:

```
npm config get prefix
```

- Typical location: `%USERPROFILE%\AppData\Roaming\npm`
- Ensure that directory is in PATH so Neovim can find `vtsls`, `typescript-language-server`, `vscode-html-language-server`, `tailwindcss-language-server`, `intelephense`, `basedpyright-langserver`.

### Go: gopls

```
go install golang.org/x/tools/gopls@latest
```

PATH for Go tools:

```
go env GOPATH
```

- Typically `C:\Users\<you>\go`; binaries are in `%GOPATH%\bin`.
- Add `%GOPATH%\bin` to PATH so Neovim finds `gopls`.

### C/C++: clangd (optional)

```
winget install --id LLVM.LLVM -e
```

`clangd` is included with LLVM; ensure `clangd.exe` is on PATH.

## Python Tools (none-ls/formatting/linting)

Prefer per-project virtual environments:

```
python -m venv .venv
. .venv\Scripts\activate
pip install black pylint ruff
```

If you want user-wide installs:

```
pip install --user black pylint ruff
```

User Scripts PATH (varies by Python version):

- `%APPDATA%\Python\Python3x\Scripts` (e.g., `C:\Users\<you>\AppData\Roaming\Python\Python312\Scripts`)
- Ensure this path is in PATH so Neovim finds `black`/`pylint`/`ruff`.

## PATH Checklist

Add these locations to PATH (depending on what you use):

- npm global: `%USERPROFILE%\AppData\Roaming\npm`
- Go tools: `%GOPATH%\bin`
- Python user scripts: `%APPDATA%\Python\Python3x\Scripts`
- LLVM bin: path that includes `clangd.exe` (winget typically adds this)

Quick PowerShell verification:

```powershell
Get-Command nvim, git, rg, fd, cmake, ninja, clang
```

## Verify in Neovim

- `:LspInfo` should list active servers (e.g., `gopls`, `vtsls`, `clangd`, `basedpyright`, `intelephense`, `html`, `tailwindcss`).
- `:checkhealth` can help confirm PATH issues.

## Notes

- If you prefer Mason-managed servers inside Neovim, it can coexist with global installs; PATH order decides which binary is used.

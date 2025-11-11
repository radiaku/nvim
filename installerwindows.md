# Windows Installer Guide (winget + Scoop)

This guide sets up Neovim and language servers on Windows using either `winget` or `Scoop`. It also covers global installs for Node-based LSPs, Go `gopls`, and optional `clangd` for C/C++.

## Prerequisites

- PowerShell (recommended)
- Git (needed for many tools and plugin managers)

## Option A: winget (recommended on Windows 10/11)

Search packages if IDs change:

```
winget search neovim
winget search nodejs
winget search python
winget search golang
winget search llvm
winget search git
```

Install core tools:

```
winget install --id Neovim.Neovim -e
winget install --id Git.Git -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Python.Python.3.12 -e
winget install --id GoLang.Go -e
winget install --id LLVM.LLVM -e   # provides clang/clangd
```

## Option B: Scoop (flexible package manager)

Install Scoop:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex
```

```
irm get.scoop.sh -outfile 'install.ps1'
# I don't care about other parameters and want a one-line command
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
```

install git first:
```
scoop install git
```

Add useful buckets (if not already):

```
scoop bucket add main
scoop bucket add extras
scoop bucket add versions
```

Install core tools (per-user):

```
scoop install git nodejs-lts go123 python312 llvm stylua 7zip cacert curl ffmpeg fzf fd gawk gzip innounp lazygit less llvm  luarocks ninja perl pipx sed sudo unzip vim wget bat ripgrep sudo terminal-icons
```

```
winget install JanDeDobbeleer.OhMyPosh --source winget
```


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

Global installs with Scoop:

- Global installs require admin. Two approaches:
  - Open an elevated PowerShell (Run as Administrator) and run:
    
    ```
    scoop install -g neovim git nodejs-lts go python llvm stylua
    ```
  - Or install `sudo` and use it to elevate:
    
    ```
    scoop install sudo
    sudo scoop install -g neovim git nodejs-lts go python llvm stylua
    ```

Scoop PATH notes:

- Per-user shims: `C:\Users\<you>\scoop\shims`
- Global shims: `C:\ProgramData\scoop\shims`
- Ensure the appropriate shims directory is in your PATH.

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

- winget: `winget install --id LLVM.LLVM -e`
- scoop: `scoop install llvm`

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
- Scoop shims (user): `C:\Users\<you>\scoop\shims`
- Scoop shims (global): `C:\ProgramData\scoop\shims`
- LLVM bin: path that includes `clangd.exe` (winget/scoop typically add this)

## Verify in Neovim

- `:LspInfo` should list active servers (e.g., `gopls`, `vtsls`, `clangd`, `basedpyright`, `intelephense`, `html`, `tailwindcss`).
- `:checkhealth` can help confirm PATH issues.

## Notes

- If you prefer Mason-managed servers inside Neovim, it can coexist with global installs; PATH order decides which binary is used.
- On Windows, `scoop install stylua` is often easiest. Alternatively: `cargo install stylua` if you have Rust.
# Windows pwsh shell

On Windows (`vim.fn.has("win32") == 1`), `core/init.lua` requires `radia.core.pwsh`, which points Neovim's `:!` / `:terminal` shell at PowerShell.

`lua/radia/core/pwsh.lua` sets:
- `shell = "pwsh"`
- `shellcmdflag` with `-NoLogo -NoProfile -ExecutionPolicy RemoteSigned`, forces UTF-8 in/out encoding, and sets `$PSStyle.OutputRendering = PlainText` (strips ANSI so Neovim parses command output cleanly).
- `shellxquote = ''`, `shellxescape = ''`.

This is the Windows counterpart to the Termux branch. → [[termux-detection]]

Related: some plugin specs carry Windows-only build instructions inline (cmake builds for native deps). → [[plugin-organization]]

File: `lua/radia/core/pwsh.lua` (required from `lua/radia/core/init.lua`)

Links: [[termux-detection]] · [[plugin-organization]] · [[index]]

#platform

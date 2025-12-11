# LSP Configuration Structure

This directory contains the LSP configuration split into modular files for better maintainability.

## File Structure

```
lua/radia/
├── plugins/
│   └── lsp.lua          # Loader file that imports all LSP configs
└── lsp/                 # All LSP configuration (outside plugins directory)
    ├── lspconfig.lua    # Main LSP config (plugin definition)
    ├── mason.lua        # Mason plugin configuration
    ├── none-ls.lua      # None-ls (null-ls) configuration
    ├── utils.lua        # Helper functions (exepath, ensure, is_termux, etc.)
    ├── settings.lua     # Shared settings (diagnostics, capabilities, venv detection)
    ├── handlers.lua     # Mason LSP handlers for each language server
    └── direct.lua       # Direct setups for Termux/system-wide installations
```

**Note:** All LSP files are in `lua/radia/lsp/` (outside plugins) to keep them organized and prevent Lazy.nvim from auto-loading helper modules.

## Module Responsibilities

### `lspconfig.lua`
- Main plugin definition for `nvim-lspconfig`
- Orchestrates all other modules
- Decides whether to use Mason handlers or direct setups

### `utils.lua`
- `exepath(bin)` - Check if binary exists on PATH
- `ensure(bin, hint)` - Ensure binary exists with Termux-aware warnings
- `is_termux()` - Detect Termux environment
- `setup_diagnostic_signs()` - Configure diagnostic signs
- `setup_node_path()` - Add project node_modules to PATH

### `settings.lua`
- `python_diagnostic_overrides` - Shared Python diagnostic settings
- `resolve_venv(start_dir)` - Find Python virtual environment
- `find_site_packages(start_dir, util)` - Locate Python site-packages
- `get_capabilities()` - Get LSP capabilities from blink.cmp or cmp-nvim-lsp

### `handlers.lua`
- Mason LSP handlers for each language server
- Used on desktop systems where Mason manages installations
- Servers: lua_ls, basedpyright, gopls, vtsls, html, tailwindcss, intelephense, kotlin_language_server, clangd, templ, omnisharp, theme_check, emmet_ls

### `direct.lua`
- Direct LSP setups that bypass Mason
- Used on Termux or when servers are installed system-wide
- Checks for binaries on PATH and configures them directly
- Same servers as handlers.lua but with additional Termux-specific logic

## How It Works

1. **Desktop/Mason setup**: Uses `handlers.lua` via Mason's setup_handlers
2. **Termux setup**: Uses `direct.lua` to configure system-installed servers
3. **Shared settings**: Both approaches use the same diagnostic overrides from `settings.lua`

## Adding a New Language Server

### For Mason-managed servers:
Add a handler in `lua/radia/lsp/handlers.lua`:
```lua
["your_server"] = function()
    lspconfig["your_server"].setup({
        capabilities = capabilities,
        -- your settings
    })
end,
```

### For Termux/direct installations:
Add setup in `lua/radia/lsp/direct.lua`:
```lua
local your_bin = utils.ensure("your-server-binary", "Install: npm i -g your-server")
if your_bin then
    lspconfig["your_server"].setup({
        capabilities = capabilities,
        -- your settings
    })
end
```

## Benefits of This Structure

- **Clarity**: Each file has a single responsibility
- **Maintainability**: Easy to find and modify server configurations
- **DRY**: Shared settings prevent duplication
- **Testability**: Modules can be tested independently
- **Cross-platform**: Clean separation between Mason and direct setups

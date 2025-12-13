-- ============================================================================
-- Neovim Configuration Entry Point
-- ============================================================================

-- Set <space> as the leader key
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Load Configuration Modules (Order Matters!)
-- ============================================================================

-- 1. Core: Bootstraps lazy.nvim, loads all plugins, and sets up core functionality
require("radia.core")

-- 2. Keymaps: Define keybindings (loaded after plugins are available)
require("radia.keymaps")

-- 3. Themes: Apply colorscheme (loaded after plugins are available)
require("radia.themes")

-- 4. Neovide: GUI-specific settings
require("radia.neovide")

-- 5. Last: Final setup and autocmds
require("radia.last")




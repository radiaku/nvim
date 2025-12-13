-- ============================================================================
-- Neovim Core Configuration
-- ============================================================================

-- Disable built-in providers
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0

-- ============================================================================
-- Lazy.nvim Bootstrap
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy.nvim....")
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Clipboard Configuration
-- ============================================================================

vim.opt.clipboard = "unnamedplus"

-- Termux clipboard provider: use Termux:API tools when available
do
  local prefix = vim.env.PREFIX
  if prefix and prefix:find("/com.termux/") then
    local set_bin = prefix .. "/bin/termux-clipboard-set"
    local get_bin = prefix .. "/bin/termux-clipboard-get"
    if vim.fn.executable(set_bin) == 1 and vim.fn.executable(get_bin) == 1 then
      vim.g.clipboard = {
        name = "termux-api",
        copy = {
          ["+"] = set_bin,
          ["*"] = set_bin,
        },
        paste = {
          ["+"] = get_bin,
          ["*"] = get_bin,
        },
        cache_enabled = 0,
      }
    else
      vim.notify(
        "Termux clipboard tools not found. Install the Termux:API app and run 'pkg install termux-api'",
        vim.log.levels.WARN
      )
    end
  end
end

-- ============================================================================
-- User Commands
-- ============================================================================

vim.api.nvim_create_user_command("Msgs", function()
  local messages = vim.api.nvim_exec2("messages", { output = true }).output
  vim.cmd("new")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(messages, "\n"))
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
end, {})

-- ============================================================================
-- Autocmds
-- ============================================================================

-- Highlight yanked text
vim.cmd([[
	autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=100}
]])

-- Enable filetype plugin
vim.cmd([[
  filetype plugin on
]])

-- ============================================================================
-- Platform-specific Configuration
-- ============================================================================

if vim.fn.has("win32") == 1 then
	require("radia.core.pwsh")
end

vim.opt.smartindent = true

-- ============================================================================
-- Lazy.nvim Plugin Setup
-- ============================================================================

local themesname = "sonokai"
_G.themesname = themesname

require("lazy").setup({
    { import = "radia.plugins" },
    { import = "radia.plugins.ui" },
    { import = "radia.plugins.files" },
    { import = "radia.plugins.navigation" },
    { import = "radia.plugins.git" },
    { import = "radia.plugins.editing" },
    { import = "radia.plugins.diagnostics" },
    { import = "radia.plugins.language" },
    { import = "radia.plugins.terminal" },
    { import = "radia.plugins.session" },
    { import = "radia.plugins.tools" },
    { import = "radia.plugins.notes" },
    -- LSP configs loaded directly
    require("radia.lsp.lspconfig"),
    require("radia.lsp.mason"),
    require("radia.lsp.none-ls"),
}, {
    install = {
        colorscheme = { themesname },
    },
    checker = {
        enabled = false,
		notify = false,
	},
	change_detection = {
		notify = true,
	},
	ui = {
		border = "rounded",
	},
})

-- ============================================================================
-- Load Settings
-- ============================================================================

require("radia.core.settings")

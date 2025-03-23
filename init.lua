-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- default settings
require("radia.default_settings")
-- Load Core
require("radia.core")
-- Load Lazy
require("radia.lazy")
-- Load Keymaps for plugin etc
require("radia.default_keymaps")
-- Load custom keymaps
require("radia.custom_keymaps")
-- Load custom function keymaps
require("radia.custom_function_keymaps")
-- setting themes
require("radia.themes")
-- settings neovide
require("radia.neovide")
-- settings after plugins
require("radia.last")




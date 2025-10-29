-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Load Core
require("radia.core")
-- Load Keymaps for plugin etc
require("radia.keymaps")
-- setting themes
require("radia.themes")
-- settings neovide
require("radia.neovide")
-- settings after plugins
require("radia.last")




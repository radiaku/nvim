-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- set shift insert to paste on insert mode
keymap.set(
	"i",
	"<S-Insert>",
	"<C-R>+",
	{ desc = "Paste with shift+insert on insert mode", noremap = true, silent = true }
)
keymap.set("i", "<A-P>", "<C-R>+", { noremap = true, silent = true, desc = "Paste with Alt+P on insert mode" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
-- keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- destory buffer
keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close Buffer (bd)" }) --  Close Buffer (bd)
keymap.set("n", "<leader>ba", ":%bd|e#|bd#<CR>", { desc = "Close Buffer All except unsaved (bd)" }) --  Close Buffer (bd)
keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close QuickFix" }) --  Close Buffer (bd)
keymap.set("n", "<leader>bk", ":q<CR>", { desc = "Quit " }) --  Close Buffer (bd)


-- move between windows, uppside done
keymap.set("n", "<M-h>", "<C-w>h", { desc = "Move to left windows", noremap = true })
keymap.set("n", "<M-l>", "<C-w>l", { desc = "Move to right windows", noremap = true })
keymap.set("n", "<M-j>", "<C-w>j", { desc = "Move to down windows", noremap = true })
keymap.set("n", "<M-k>", "<C-w>k", { desc = "Move to upper windows", noremap = true })

-- disable for performance ( god speed)
-- keymap.set("n", "<leader>gp", ":lua ToggleFeatures()<CR>", { desc = "Disable almost anything", noremap = true })

-- Set a keymap to trigger buffer formatting
-- keymap.set("n", "<leader>fp", function() vim.lsp.buf.formatting_sync() end, { desc = "Format Buffer", noremap = true })

-- disable format
-- keymap.set("n", "<leader>fd", "<cmd>FormatDisable<CR>", { desc = "Disable Format", noremap = true })

-- enable format
-- keymap.set("n", "<leader>fe", "<cmd>FormatEnable<CR>", { desc = "Enable Format", noremap = true })

-- change working directory to the location of the current file
keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Changing Working Directory", noremap = true })
-- keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Changing Working Directory", noremap = true })
--

-- resize split
keymap.set("n", "<M-,>", "<C-w>5<")
keymap.set("n", "<M-.>", "<C-w>5>")
keymap.set("n", "<M-u>", "<C-w>+")
keymap.set("n", "<M-d>", "<C-w>-")
keymap.set("n", "<M-f>", "<C-w>=")

-- reset font
keymap.set("n", "<M-0>", "<cmd>:GuiFont! JetBrainsMono Nerd Font:h14<CR>")

-- save all
keymap.set("n", "<leader>sa", ":wa<CR>", { desc = "Save all", noremap = true })
-- quit force
keymap.set("n", "<leader>qf", ":q!<CR>", { desc = "Save all", noremap = true })

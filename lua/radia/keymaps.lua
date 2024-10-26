vim.cmd([[
set mouse=a
" source $VIMRUNTIME/mswin.vim
" imap <S-Insert> <C-R>*
" noremap y "*y
" noremap yy "*yy
" noremap Y "*y$
"
" imap <silent>  <C-R>+
imap <C-v> <C-R>*
cmap <S-Insert>  <C-R>+

" ON toggleterm or terminal change to normal mode"
tnoremap <C-\> <C-\><C-N>
tnoremap <C-t> <C-\><C-N>:ToggleTerm<CR>
tnoremap <Esc> <C-\><C-N> 
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l

" tnoremap <C-S-h> <C-\><C-N><C-w>h
" tnoremap <C-S-j> <C-\><C-N><C-w>j
" tnoremap <C-S-k> <C-\><C-N><C-w>k
" tnoremap <C-S-l> <C-\><C-N><C-w>l

]])

local keymap = vim.keymap -- for conciseness

-- ctrl+shift+v
-- keymap.set("c", "<M-v>", "<C-R>+", { desc="ctrl+shift+v paste neovim", noremap = true, silent = true })

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- set shift insert to paste on insert mode
keymap.set("i", "<S-Insert>", "<C-R>+", { desc = "Paste with shift+insert", noremap = true, silent = true })
keymap.set("i", "<A-P>", "<C-R>+", { noremap = true, silent = true, desc = "Paste with Alt+P on insert mode" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Hop
keymap.set("n", "t", "<cmd>HopPattern<CR>", { desc = "Hop", noremap = true })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
-- keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- destory buffer
keymap.set("n", "<leader>bd", "<cmd>bd!<CR>", { desc = "Close Buffer (bd)" }) --  Close Buffer (bd)
keymap.set("n", "<leader>ba", ":%bd|e#|bd#<CR>", { desc = "Close Buffer All except unsaved (bd)" }) --  Close Buffer (bd)
-- keymap.set("n", "<leader>baf", ":qa!", { desc = "Kill all and exit" })
keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close QuickFix" }) --  Close Buffer (bd)
keymap.set("n", "<leader>co", "::only<CR>", { desc = "Close Other Split windows" })
keymap.set("n", "<leader>bk", ":q!<CR>", { desc = "Quit " }) --  Close Buffer (bd)

-- move between windows, uppside done on mac set to iterm2
-- \<C-w>h on profile
-- keymap.set("n", "<M-h>", "<C-w>h", { desc = "Move to left windows", noremap = true })
-- keymap.set("n", "<M-l>", "<C-w>l", { desc = "Move to right windows", noremap = true })
-- keymap.set("n", "<M-j>", "<C-w>j", { desc = "Move to down windows", noremap = true })
-- keymap.set("n", "<M-k>", "<C-w>k", { desc = "Move to upper windows", noremap = true })

-- keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left windows", noremap = true })
-- keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right windows", noremap = true })
-- keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down windows", noremap = true })
-- keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper windows", noremap = true })

-- Move Between tab buffer
keymap.set(
	"n",
	"<S-l>",
	"<CMD>BufferLineCycleNext<CR>",
	{ desc = "Move to left tab buffer", noremap = true, silent = true }
)
keymap.set(
	"n",
	"<S-h>",
	"<CMD>BufferLineCyclePrev<CR>",
	{ desc = "Move to right tab buffer", noremap = true, silent = true }
)

keymap.set(
	"n",
	"<C-l>",
	"<CMD>BufferLineMoveNext<CR>",
	{ desc = "Move buffer to next left", noremap = true, silent = true }
)
keymap.set(
	"n",
	"<C-h>",
	"<CMD>BufferLineMovePrev<CR>",
	{ desc = "Move buffer to right", noremap = true, silent = true }
)

-- change working directory to the location of the current file
keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Changing Working Directory", noremap = true })
-- keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Changing Working Directory", noremap = true })

-- resize split
keymap.set("n", "<C-,>", "<C-w>5<", { desc = "Resize to right" })
keymap.set("n", "<C-.>", "<C-w>5>", { desc = "Resize to Left" })
keymap.set("n", "<C-u>", "<C-w>+", { desc = "Resize Up" })
keymap.set("n", "<C-d>", "<C-w>-", { desc = "Resize Down" })
keymap.set("n", "<C-f>", "<C-w>=", { desc = "Resize F" })

-- keymap.set("n", "<M-,>", "<C-w>5<", { desc = "Resize to right" })
-- keymap.set("n", "<M-.>", "<C-w>5>", { desc = "Resize to Left" })
-- keymap.set("n", "<M-u>", "<C-w>+", { desc = "Resize Up" })
-- keymap.set("n", "<M-d>", "<C-w>-", { desc = "Resize Down" })
-- keymap.set("n", "<M-f>", "<C-w>=", { desc = "Resize F" })

-- reset font
keymap.set("n", "<M-0>", "<cmd>:GuiFont! JetBrainsMono Nerd Font:h14<CR>", { desc = "Reset Font" })

-- save all
keymap.set("n", "<leader>sa", ":wa<CR>", { desc = "Save all", noremap = true })
-- quit force
keymap.set("n", "<leader>qf", ":q!<CR>", { desc = "quit force all", noremap = true })

-- Plugin map
local opts = { noremap = true, silent = true }

-- conform
local conform = require("conform")
keymap.set({ "n", "v" }, "<leader>rf", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file" })

-- Recall
-- local recall = require("recall")
-- keymap.set("n", "<leader>ma", "<cmd>RecallMark<CR>", { desc = "RecallMark", noremap = true, silent = true })
-- keymap.set("n", "<leader>md", "<cmd>RecallUnmark<CR>", { desc = "RecallUnMark", noremap = true, silent = true })
-- keymap.set("n", "<leader>mm", recall.toggle, { desc = "Toggle Recall", noremap = true, silent = true })
-- keymap.set("n", "<leader>mn", recall.goto_next, { desc = "Next Recall Mark", noremap = true, silent = true })
-- keymap.set("n", "<leader>mp", recall.goto_prev, { desc = "Previous Recall Mark", noremap = true, silent = true })
-- keymap.set("n", "<leader>mc", recall.clear, { desc = "Clear Recall Mark", noremap = true, silent = true })
-- keymap.set(
-- 	"n",
-- 	"<leader>mt",
-- 	":Telescope recall theme=dropdown<CR>",
-- 	{ desc = "Recall Telescope", noremap = true, silent = true }
-- )

-- Lsp
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts_lsp = { buffer = ev.buf, silent = true }

		-- set keybinds
		opts_lsp.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>Telescope lsp_references theme=dropdown<CR>", opts_lsp) -- show definition, references

		opts_lsp.desc = "Show LSP type all References"
		keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts_lsp) -- Show LSP type all References

		opts_lsp.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts_lsp) -- go to declaration

		opts_lsp.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts_lsp) -- show lsp definitions

		opts_lsp.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts_lsp) -- show lsp implementations

		opts_lsp.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts_lsp) -- show lsp type definitions

		opts_lsp.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts_lsp) -- see available code actions, in visual mode will apply to selection

		opts_lsp.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts_lsp) -- smart rename

		opts_lsp.desc = "Show buffer diagnostics"
		keymap.set("n", "gf", "<cmd>Telescope diagnostics bufnr=0<CR>", opts_lsp) -- show  diagnostics for file

		opts_lsp.desc = "Show line diagnostics"
		keymap.set("n", "gl", vim.diagnostic.open_float, opts_lsp) -- show diagnostics for line

		opts_lsp.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", vim.diagnostic.goto_prev, opts_lsp) -- jump to previous diagnostic in buffer

		opts_lsp.desc = "Go to next diagnostic"
		keymap.set("n", "]d", vim.diagnostic.goto_next, opts_lsp) -- jump to next diagnostic in buffer

		opts_lsp.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts_lsp) -- show documentation for what is under cursor

		opts_lsp.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts_lsp) -- mapping to restart lsp if necessary
	end,
})

-- Debug
keymap.set("n", "<leader>dt", ":DapUiToggle<CR>", { desc = "Open DapUi" })
keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
keymap.set("n", "<leader>ds", ":lua require('dap').run_to_cursor()<CR>", { desc = "Run Dap Under Cursor" })
keymap.set("n", "<leader>drc", ":lua require('dap').continue()<CR>", { desc = "Run Continue" })
keymap.set("n", "<leader>drs", ":lua require('dap').restart()<CR>", { desc = "Restart Dap" })
keymap.set("n", "<leader>dO", ":lua require('dap').step_out()<CR>", { desc = "Step Out" })
keymap.set("n", "<leader>do", ":lua require('dap').step_over()<CR>", { desc = "Step Over" })
keymap.set("n", "<leader>di", ":lua require('dap').step_into()<CR>", { desc = "Step Into" })
keymap.set("n", "<leader>da", ":lua require('dap').step_back()<CR>", { desc = "Step Back" })
keymap.set("n", "<leader>dc", ":lua require('dapui').open({ reset = true })<CR>", { desc = "Reset Dapui" })

-- Folding
keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open AllFolds" })
keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close AllFolds" })

-- Todo Telescope
keymap.set("n", "<leader>td", ":TodoTelescope<CR>", { noremap = true, desc = "Todo Telescope" })
keymap.set("n", "<leader>tq", ":TodoQuickFix<CR>", { noremap = true, desc = "Todo QuickFix" })

-- Toggle Term aka terminal
keymap.set("n", "<C-t>", ":ToggleTerm<CR>", { desc = "ToggleTerm", noremap = true })

-- Telescope map
keymap.set("i", "<C-o>", "<cmd>:Telescope neoclip <CR>", { desc = "Find Clipboard on Edit" })
keymap.set("n", "<leader>fo", "<cmd>:Telescope neoclip <CR>", { desc = "Find Clipboard" })
keymap.set(
	"v",
	"<leader>fo",
	"<cmd>:lua require('telescope.builtin').registers({ layout_strategy='vertical', layout_config={ height=100 } })<CR>",
	{ desc = "Find Clipboard Visual" }
)
keymap.set(
	"n",
	"<leader>fg",
	"<cmd>:lua require('telescope.builtin').registers({layout_strategy='vertical',layout_config={height=100}})<cr>",
	{ desc = "Find Registers" }
)
keymap.set(
	"n",
	"<leader>fm",
	"<cmd>:lua require('telescope.builtin').keymaps({layout_strategy='vertical',layout_config={height=100}})<cr>",
	{ desc = "Find Keymaps" }
)
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files theme=dropdown<cr>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles theme=dropdown<cr>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep <cr>", { desc = "Find string in cwd" })
keymap.set(
	"n",
	"<leader>fa",
	"<cmd>Telescope buffers show_all_buffers=true sort_lastused=true theme=dropdown<cr>",
	{ desc = "Find buffer on buffers" }
)
-- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
local live_grep_cmdc_buffer =
	'<cmd>Telescope live_grep search_dirs={"%:p"} vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings --theme=dropdown<cr>'
keymap.set("n", "<leader>fb", live_grep_cmdc_buffer, { desc = "Find string in current buffer" })
local live_grep_cmd =
	'<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true,layout_strategy=vertical,layout_config={height=100}})<CR>'
keymap.set("n", "<leader>fl", live_grep_cmd, { desc = "Find string in all open buffers" })

-- File Neotree
keymap.set("n", "<leader>ee", ":Neotree toggle float<CR>", { desc = "Float File Explore", silent = true })
keymap.set("n", "<leader>ef", ":Neotree toggle left<CR>", { desc = "Left File Explorer", silent = true })

-- Spectre
-- keymap.set("n", "<leader>sr", '<cmd>lua require("spectre").toggle()<CR>', {
-- 	desc = "Toggle Spectre",
-- })
-- keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
-- 	desc = "Search current word",
-- })
-- keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
-- 	desc = "Search current word",
-- })
-- keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
-- 	desc = "Search on current file",
-- })

-- Line Operation, Moving block or line
opts.desc = "Move BlockLine Down"
keymap.set("v", "<S-j>", ":MoveBlock(1)<CR>", opts)
opts.desc = "Move BlockLine Up"
keymap.set("v", "<S-k>", ":MoveBlock(-1)<CR>", opts)
-- keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
-- keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)

-- LazyGit
keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Toggle Lazygit" })

-- Harpoon
local harpoon = require("harpoon")
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local finder = function()
		local paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(paths, item.value)
		end

		return require("telescope.finders").new_table({
			results = paths,
		})
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = finder(),
			-- previewer = conf.file_previewer({}),
			previewer = false,
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				map("n", "dd", function()
					local state = require("telescope.actions.state")
					local selected_entry = state.get_selected_entry()
					local current_picker = state.get_current_picker(prompt_bufnr)

					table.remove(harpoon_files.items, selected_entry.index)
					current_picker:refresh(finder())
				end)
				return true
			end,
		})
		:find()
end

keymap.set("n", "<leader>hm", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })
keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "+Add to harpoon" })

keymap.set("n", "<leader>hn", function()
	harpoon:list():next()
end, { desc = "Next Harpoon" })

keymap.set("n", "<leader>hp", function()
	harpoon:list():prev()
end, { desc = "Previous Harpoon" })

-- Trouble
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)", noremap = true })
-- Obsidian Search
keymap.set("n", "<leader>so", "<cmd>ObsidianSearch<cr>", { desc = "Search Obsidian Note", noremap = true })
keymap.set("n", "<leader>sn", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian Note", noremap = true })
-- Mark
keymap.set("n", "<leader>ml", "<cmd>:MarksQFListBuf<cr>", { desc = "List Mark On Buffer", noremap = true })

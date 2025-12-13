local map = require("radia.keymaps.helper").map

-- BufferLine navigation
map("n", "<C-l>", ":BufferLineCycleNext<cr>", "Navigate to left tab from current buffer")
map("n", "<C-h>", ":BufferLineCyclePrev<cr>", "Navigate to to right tab from current buffer")
map("n", "<C-n>", ":BufferLineMoveNext<CR>", "Move buffer to next left")
map("n", "<C-p>", ":BufferLineMovePrev<CR>", "Move buffer to right")

-- QuickFix clear command
function ClearQuickfixList()
  vim.fn.setqflist({})
end
vim.api.nvim_create_user_command("ClearQuickfixList", ClearQuickfixList, {})
map("n", "<leader>cf", ":ClearQuickfixList<CR>", "clear QuickFix")

-- Conform formatting
local conform = require("conform")
map({ "n", "v" }, "<leader>rf", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 5000,
  })
end, "Format file")

-- Folding
map("n", "zR", require("ufo").openAllFolds, "Open AllFolds")
map("n", "zM", require("ufo").closeAllFolds, "Close AllFolds")

-- Todo
map("n", "<leader>td", ":TodoTelescope<CR>", "Todo Telescope")
map("n", "<leader>tq", ":TodoQuickFix<CR>", "Todo QuickFix")

-- Terminal
map("n", "<C-t>", ":ToggleTerm<CR>", "ToggleTerm")

-- Telescope
map("n", "<leader>fc", "<cmd>:Telescope neoclip <CR>", "Find Clipboard Normal")
map("n", "<leader>fd", "<cmd>:Telescope lsp_document_symbols <CR>", "Find lsp_document_symbols")
map("v", "<leader>fc", "<cmd>:lua require('telescope.builtin').registers({ layout_strategy='vertical', layout_config={ height=100 } })<CR>", "Find Clipboard Visual")
map("n", "<leader>fr", "<cmd>:lua require('telescope.builtin').registers({layout_strategy='vertical',layout_config={height=100}})<cr>", "Find Registers")
map("n", "<leader>fm", "<cmd>:lua require('telescope.builtin').keymaps({layout_strategy='vertical',layout_config={height=100}})<cr>", "Find Keymaps")
map("n", "<leader>ff", "<cmd>Telescope find_files theme=ivy previewer=false<cr>", "Fuzzy find files in cwd")
map("n", "<leader>fh", "<cmd>Telescope find_files theme=ivy previewer=false hidden=true no_ignore=true<cr>", "Fuzzy find files in cwd with hidden")

map("n", "<leader>fs", function()
  require('telescope').extensions.live_grep_args.live_grep_args({
    default_text = '-F ',
  })
end, "Find string in cwd")

map("n", "<leader>fx", function()
  require("telescope").extensions.live_grep_args.live_grep_args({
    cwd = vim.fn.stdpath("config"),
    default_text = "-F ",
  })
end, "Find string in config (hidden, fixed)")

map("n", "<leader>fa", "<cmd>Telescope buffers show_all_buffers=true sort_lastused=true theme=dropdown<cr>", "Find buffer on buffers")
map("n", "<leader>fc", '<cmd>Telescope live_grep search_dirs={"%:p"} vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings --theme=ivy<cr>', "Find string in current buffer")
map("n", "<leader>fb", '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true,layout_strategy=vertical,layout_config={height=100}})<CR>', "Find string in all open buffers")

-- Neotree
map("n", "<leader>ee", ":Neotree toggle float<CR>", "Float File Explore")
map("n", "<leader>ef", ":Neotree toggle left<CR>", "Left File Explorer")

-- Line movement
map("v", "<S-j>", ":MoveBlock(1)<CR>", "Move BlockLine Down")
map("v", "<S-k>", ":MoveBlock(-1)<CR>", "Move BlockLine Up")

-- LazyGit
map("n", "<leader>lg", "<cmd>LazyGit<cr>", "Toggle Lazygit")

-- Harpoon
local harpoon = require("harpoon")
local conf = require("telescope.config").values

local function toggle_telescope(harpoon_files)
  local finder = function()
    local paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(paths, item.value)
    end
    return require("telescope.finders").new_table({ results = paths })
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = finder(),
    previewer = false,
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map_key)
      map_key("n", "dd", function()
        local state = require("telescope.actions.state")
        local selected_entry = state.get_selected_entry()
        local current_picker = state.get_current_picker(prompt_bufnr)
        table.remove(harpoon_files.items, selected_entry.index)
        current_picker:refresh(finder())
      end)
      return true
    end,
  }):find()
end

map("n", "<leader>hm", function() toggle_telescope(harpoon:list()) end, "Open harpoon window")
map("n", "<leader>ha", function() harpoon:list():add() end, "+Add to harpoon")
map("n", "<leader>hn", function() harpoon:list():next() end, "Next Harpoon")
map("n", "<leader>hp", function() harpoon:list():prev() end, "Previous Harpoon")

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")

-- Obsidian
map("n", "<leader>so", "<cmd>ObsidianSearch<cr>", "Search Obsidian Note")
map("n", "<leader>sn", "<cmd>ObsidianNew<cr>", "New Obsidian Note")

-- Mark
map("n", "<leader>ml", "<cmd>:MarksQFListBuf<cr>", "List Mark On Buffer")

-- Neogit
map("n", "<leader>ng", ":Neogit kind=floating<CR>", "Neogit")

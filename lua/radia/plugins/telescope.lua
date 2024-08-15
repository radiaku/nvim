return {
  -- NOTE JIKA ERROR di windows
  -- instal fzf error
  --
  -- REMEMBER you need install cmake on windows 
  --
  -- cd ~/AppData/Local/nvim-data/lazy/telescope-fzf-native.nvim
  -- run this:
  -- cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build
  --
  --
  -- check build/Release
  -- fzf.exp
  -- fzf.lib
  -- libfzf.dll
  --
  -- and done
  -- taken from this for fixing on windows https://github.com/LunarVim/LunarVim/issues/1804	}
  --
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    -- 	{ "nvim-telescope/telescope-fzy-native.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local keymap = require("vim.keymap")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- telescope.load_extension("fzy_native")
    telescope.load_extension("fzf")

    -- set keymaps
    -- keymap.remove("n", "<leader>fb")

    keymap.set("n", "<leader>km", "<cmd>:lua require('telescope.builtin').keymaps()<cr>", { desc = "Show Keymaps" })
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set(
      "n",
      "<leader>fm",
      "<cmd>Telescope buffers show_all_buffers=true<cr>",
      { desc = "Find string in cwd" }
    )
    -- keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set(
      "n",
      "<leader>fb",
      -- '<cmd>Telescope live_grep search_dirs={"%:p"} vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings<cr>',
      '<cmd>Telescope live_grep search_dirs={"%:p"} vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--fixed-strings<cr>',
      { desc = "Find string in current buffer" }
    )
    keymap.set(
      "n",
      "<leader>fl",
      [[<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>]],
      { desc = "Find string in all open buffer" }
    )
  end,
}

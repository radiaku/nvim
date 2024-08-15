return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- set keymaps
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({})
		-- REQUIRED
		--
		-- basic telescope configuration
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

    local keymap = vim.keymap -- for conciseness

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


  end,
}

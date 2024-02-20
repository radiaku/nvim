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
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>hm", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })

		keymap.set("n", "<leader>ha", function()
			harpoon:list():append()
		end)

		-- keymap.set("n", "<leader>hb", function()
		-- 	require("harpoon.mark").add_file()
		-- end, "Mark file")

		-- keymap.set(
		-- 	"n",
		-- 	"<leader>hh",
		-- 	"<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
		-- 	{ desc = "Go to next harpoon mark" }
		-- )

		-- keymap.set(
		-- 	"n",
		-- 	"<leader>hn",
		-- 	"<cmd>lua require('harpoon.ui').nav_next()<cr>",
		-- 	{ desc = "Go to next harpoon mark" }
		-- )
		--
		-- keymap.set(
		-- 	"n",
		-- 	"<leader>hp",
		-- 	"<cmd>lua require('harpoon.ui').nav_prev()<cr>",
		-- 	{ desc = "Go to previous harpoon mark" }
		-- )
	end,
}

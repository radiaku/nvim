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

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
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
		telescope.load_extension("neoclip")
		telescope.load_extension("fzf")
		-- telescope.load_extension("refactoring")

		-- set keymaps
		-- keymap.remove("n", "<leader>fb")
	end,
}

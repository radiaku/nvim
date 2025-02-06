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
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		local previewers = require("telescope.previewers")

		local function count_lines(filepath)
			local file = io.open(filepath, "r")
			if not file then
				-- print("Could not open file: " .. filepath)
				return 0
			end

			local count = 0
			for _ in file:lines() do
				count = count + 1
			end
			file:close()
			-- print("Line count: " .. count)
			return count
		end

		local no_preview_minified = function(filepath, bufnr, opts)
			local max_char_count = 10000
			local min_line_count = 50
			local max_bytes = 10000

			local ok, stats = pcall(vim.loop.fs_stat, filepath)
			local linecount = count_lines(filepath)

			-- print("size:", ok and stats and stats.size, "line count:", linecount, "filepath", filepath)

			opts = opts or {}

			if ok and stats then
				local char_count = stats.size
				local line_count = linecount

				if char_count > max_char_count and line_count < min_line_count then
					-- local cmd = { "echo", "char_larger" }
					local cmd = { "head", "-c", max_bytes, filepath }
					require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
					return
				end
			end

			if linecount > 500000 then
				local cmd = { "head", "-c", max_bytes, filepath }
				-- local cmd = { "echo", "limit_line" }
				require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
				return
			end

			previewers.buffer_previewer_maker(filepath, bufnr, opts)
		end

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					".git",
					"venv",
				},
				buffer_previewer_maker = no_preview_minified,
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
				preview = {
					timeout_hook = function(filepath, bufnr, opts)
						local cmd = { "echo", "timeout" }
						require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
					end,
					filesize_hook = function(filepath, bufnr, opts)
						local cmd = { "echo", "filesize" }
						require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
					end,
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		-- telescope.load_extension("fzy_native")
		telescope.load_extension("neoclip")
		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		-- telescope.load_extension("refactoring")

		-- set keymaps
		-- keymap.remove("n", "<leader>fb")
	end,
}

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
	commit = "a4ed82",
	-- branch = "0.1.x",
	dependencies = {
		-- 	{ "nvim-telescope/telescope-fzy-native.nvim" },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			commit = "1f08ed",
			build = function()
				local prefix = vim.env.PREFIX or ""
				local is_termux = prefix:find("com%.termux") ~= nil
				local has_make = vim.fn.executable("make") == 1
				local has_cmake = vim.fn.executable("cmake") == 1
				local has_clang = vim.fn.executable("clang") == 1

				local function run(cmd)
					local ok = false
					if vim.system then
						local res = vim.system({ "sh", "-lc", cmd }, { text = true }):wait()
						ok = (res and res.code == 0)
					else
						vim.fn.system(cmd)
						ok = (vim.v.shell_error == 0)
					end
					return ok
				end

				local ok = false
				if has_make then
					if is_termux and has_clang then
						ok = run("make clean") and run("make CC=clang")
					else
						ok = run("make clean") and run("make")
					end
				end

				if (not ok) and has_cmake then
					ok = run("cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release")
						and run("cmake --build build --config Release")
				end
				-- Never error out; extension load is guarded below
			end,
		},
		{ "nvim-telescope/telescope-live-grep-args.nvim", commit = "b80ec2" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		local previewers = require("telescope.previewers")

    local utils = require("telescope.previewers.utils")

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

		-- count_lines(filepath) must be defined somewhere else in your file:
		--   it should return a number (or nil on error)

		local no_preview_minified = function(filepath, bufnr, opts)
			opts = opts or {}

			local max_char_count = 10000 -- if file bigger than this, we start being careful
			local min_line_count = 50 -- "few lines" threshold (likely minified)
			local max_preview_len = 10000 -- bytes to show with head -c
			local insane_line_cnt = 500000 -- absurdly many lines: also clip preview

			-- get file stats first
			local ok, stats = pcall(vim.loop.fs_stat, filepath)
			if not (ok and stats and stats.size) then
				-- if we can’t stat, just fall back to normal preview
				return previewers.buffer_previewer_maker(filepath, bufnr, opts)
			end

			local size = stats.size

			-- For small files, just use normal previewer
			if size <= max_char_count then
				return previewers.buffer_previewer_maker(filepath, bufnr, opts)
			end

			-- Only now pay the cost of counting lines (since we know file is big)
			local linecount = count_lines(filepath) or 0

			-- Case 1: big file but very few lines → probably minified
			if size > max_char_count and linecount > 0 and linecount < min_line_count then
				local cmd = { "head", "-c", tostring(max_preview_len), filepath }
				utils.job_maker(cmd, bufnr, opts)
				return
			end

			-- Case 2: ridiculous line count → clip preview as well
			if linecount > insane_line_cnt then
				local cmd = { "head", "-c", tostring(max_preview_len), filepath }
				utils.job_maker(cmd, bufnr, opts)
				return
			end

			-- Default: normal preview
			return previewers.buffer_previewer_maker(filepath, bufnr, opts)
		end

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--no-ignore",
					"--glob",
					"!**/.git/*",
				},
				file_ignore_patterns = {
					"node_modules",
					"%.git/",
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
						["<C-p>"] = actions.move_selection_previous,
						["<C-n>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
					n = {
						["x"] = actions.toggle_selection + actions.move_selection_better,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<C-p>"] = actions.move_selection_previous,
						["<C-n>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-Q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true,
				},
			},
		})

		-- telescope.load_extension("fzy_native")
		telescope.load_extension("neoclip")

		local function ensure_fzf_native_built()
			local dir = vim.fn.stdpath("data") .. "/lazy/telescope-fzf-native.nvim"
			local lib = dir .. "/build/libfzf.so"
			if vim.fn.filereadable(lib) == 1 then
				return true
			end
			local has_make = vim.fn.executable("make") == 1
			if has_make == false then
				return false
			end
			local prefix = vim.env.PREFIX or ""
			local is_termux = prefix:find("com%.termux") ~= nil
			local has_clang = vim.fn.executable("clang") == 1
			local cmd = (is_termux and has_clang) and "make CC=clang" or "make"
			local ok = false
			if vim.system then
				local res = vim.system(
					{ "sh", "-lc", "cd " .. vim.fn.shellescape(dir) .. " && make clean && " .. cmd },
					{ text = true }
				):wait()
				ok = (res and res.code == 0)
			else
				vim.fn.system("cd " .. dir .. " && make clean && " .. cmd)
				ok = (vim.v.shell_error == 0)
			end
			return ok and (vim.fn.filereadable(lib) == 1)
		end

		local ok_fzf = pcall(require("telescope").load_extension, "fzf")
		if not ok_fzf then
			if ensure_fzf_native_built() then
				pcall(require("telescope").load_extension, "fzf")
			else
				-- Only notify in Termux; stay quiet elsewhere
				local prefix = vim.env.PREFIX or ""
				local in_termux = prefix:find("com%.termux") ~= nil
				if in_termux then
					vim.notify(
						"telescope-fzf-native is not built. Install build tools and run :Lazy build telescope-fzf-native.nvim",
						vim.log.levels.WARN
					)
				end
			end
		end

		telescope.load_extension("live_grep_args")
		-- telescope.load_extension("refactoring")

		-- set keymaps
		-- keymap.remove("n", "<leader>fb")
	end,
}

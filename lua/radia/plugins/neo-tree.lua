return {
	"nvim-neo-tree/neo-tree.nvim",
	commit = "522446",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "MunifTanjim/nui.nvim", commit = "8d3bce" },
	},
	event = "VeryLazy",
	config = function()
		require("neo-tree").setup({

			close_if_last_window = true,
			popup_border_style = "single",
			enable_git_status = true,
			enable_modified_markers = true,
			enable_diagnostics = true,
			sort_case_insensitive = true,
			default_component_configs = {
				indent = {
					with_markers = true,
					with_expanders = true,
				},
				modified = {
					symbol = " ",
					highlight = "NeoTreeModified",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "",
					folder_empty_open = "",
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "",
						deleted = "",
						modified = "",
						renamed = "",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
				},
			},
			window = {
				position = "float",
				width = 35,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["y"] = function(state)
						-- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
						-- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
						local node = state.tree:get_node()
						local filename = node.name
						vim.fn.setreg("*", filename)
						vim.fn.setreg('"', filename)
						vim.fn.setreg("1", filename)
						vim.fn.setreg("+", filename)
						vim.notify("Copied: " .. filename)
					end,
					["Y"] = function(state)
						-- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
						-- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						vim.fn.setreg("*", filepath)
						vim.notify("Copied: " .. filepath)
					end,

					["<space>"] = {
						"toggle_node",
						nowait = false,
					},

					-- ["<2-LeftMouse>"] = "open",
					["o"] = { "open", config = { nowait = false } },
					["oc"] = "noop",
					["od"] = "noop",
					["og"] = "noop",
					["om"] = "noop",
					["on"] = "noop",
					["os"] = "noop",
					["ot"] = "noop",

					["."] = "set_root",
					["h"] = "toggle_hidden",

					["<esc>"] = "cancel", -- close preview or floating neo-tree window
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					["l"] = "focus_preview",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["w"] = "open_with_window_picker",
					["z"] = "close_node",
					["Z"] = "close_all_nodes",
					["a"] = {
						"add",
						config = {
							show_path = "none",
						},
					},

					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["C"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
					["i"] = "show_file_details",
				},
			},
			filesystem = {
				-- set disable for windows user
				use_libuv_file_watcher = false,
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},

				filtered_items = {
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_by_name = {
						"node_modules",
					},
					never_show = {
						".git",
						".DS_Store",
						"thumbs.db",
					},
				},
			},
		})
	end,
}

if vim.g.neovide then
	vim.o.guifont = "JetBrainsMono Nerd Font:h11"
	vim.opt.linespace = 1
	vim.g.transparency = 0

	vim.g.neovide_transparency = 0.8
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_window_floating_opacity = 0
	vim.g.neovide_floating_blur = 0
	vim.g.neovide_window_floating_blur = 0

	vim.g.neovide_scroll_animation_length = 0

	vim.g.neovide_theme = "auto"
	vim.g.neovide_refresh_rate = 120
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_length = 2
	vim.g.neovide_cursor_antialiasing = true

	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_in_normal_mode = false
	vim.g.neovide_cursor_animate_in_visual_mode = false
	vim.g.neovide_cursor_animate_in_replace_mode = false
	vim.g.neovide_cursor_animate_in_command_mode = false
	vim.g.neovide_cursor_animate_in_term_mode = false
end

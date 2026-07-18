return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			-- Prefer a lean style to avoid overlapping code visually
			preset = "minimal",
			transparent_bg = true,
			transparent_cursorline = true,
			hi = {
				background = "None",
				mixing_color = "None",
			},
			virt_texts = { priority = 2048 },
			severity = {
				vim.diagnostic.severity.ERROR,
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.INFO,
				vim.diagnostic.severity.HINT,
			},
			options = {
				add_messages = {
					messages = true,
					display_count = false,
					use_max_severity = true,
					show_multiple_glyphs = true,
				},
				multilines = {
					enabled = true,
					always_show = false, -- only expand under cursor; cuts redraw thrash
				},
				show_source = { enabled = false },
				-- Higher throttle: bulk external reloads + hjkl used to re-render every line
				throttle = 250,
			},
			-- Skip BufReadPost: silent reloads after external edits would re-attach every buffer
			overwrite_events = { "LspAttach", "BufEnter" },
			disabled_ft = {},
		})
		vim.diagnostic.config({ virtual_text = false, update_in_insert = false })
	end,
}

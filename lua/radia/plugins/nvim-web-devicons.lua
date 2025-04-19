return {
	"nvim-tree/nvim-web-devicons",
	commit = "c90dee",
	config = function()
		require("nvim-web-devicons").set_icon({
			gql = {
				icon = "",
				color = "#e535ab",
				cterm_color = "199",
				name = "GraphQL",
			},
		})
	end,
}

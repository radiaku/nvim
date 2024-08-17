local function set_filetype()
	local extension = vim.fn.expand("%:e")
	if extension == "tmpl" or extension == "gotext" or extension == "gohtml" then
		vim.bo.filetype = "html"
	end
end

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = set_filetype,
})

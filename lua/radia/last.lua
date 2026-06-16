local function set_filetype()
	local extension = vim.fn.expand("%:e")
	if extension == "tmpl" or extension == "gotext" or extension == "gohtml" then
		vim.bo.filetype = "html"
	end
	if extension == "mq5" then
		vim.bo.filetype = "cpp"
	end
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = set_filetype,
})

-- Clean up stale ShaDa temp files on startup to prevent E138
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local shada_dir = vim.fn.stdpath("data") .. "/shada"
		if vim.fn.isdirectory(shada_dir) == 0 then
			return
		end
		for name, _ in vim.fs.dir(shada_dir) do
			if name:match("^main%.shada%.tmp%.") then
				vim.fn.delete(shada_dir .. "/" .. name)
			end
		end
	end,
})

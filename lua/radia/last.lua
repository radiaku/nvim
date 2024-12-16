local function set_filetype()
	local extension = vim.fn.expand("%:e")
	if extension == "tmpl" or extension == "gotext" or extension == "gohtml" then
		vim.bo.filetype = "html"
	end
	if extension == "mq5" then
		vim.bo.filetype = "cpp"
	end
end

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = set_filetype,
})

-- vim.g.VM_show_warnings = 0
--

-- -- Function to count nodes in a Tree-sitter tree
-- function _G.count_nodes_in_treesitter()
-- 	local parser = vim.treesitter.get_parser(0) -- Get the parser for the current buffer
-- 	if not parser then
-- 		print("No parser available for the current buffer.")
-- 		return
-- 	end

-- 	local tree = parser:parse()[1] -- Get the first syntax tree
-- 	if not tree then
-- 		print("Failed to parse the syntax tree.")
-- 		return
-- 	end

-- 	local function count_nodes(node)
-- 		local count = 1 -- Count the current node
-- 		for child in node:iter_children() do
-- 			count = count + count_nodes(child)
-- 		end
-- 		return count
-- 	end

-- 	local total_nodes = count_nodes(tree:root())
-- 	print("Total Tree-sitter nodes:", total_nodes)
-- end

-- -- Map the function to <leader>ip
-- vim.api.nvim_set_keymap(
-- 	"n", -- Normal mode
-- 	"<leader>ip", -- Key combination
-- 	":lua _G.count_nodes_in_treesitter()<CR>", -- Command to execute
-- 	{ noremap = true, silent = true } -- Options
-- )

-- -- Function to count nodes and control Tree-sitter
-- function _G.control_treesitter_on_autocmd()
-- 	local filetype = vim.bo.filetype -- Get the current buffer's filetype
-- 	if filetype == "" or filetype == "neo-tree" then
-- 		return -- Skip if the filetype is not set or is 'neo-tree'
-- 	end
--
-- 	local parser_ok, parser = pcall(vim.treesitter.get_parser, 0, filetype, {})
-- 	if not parser_ok or not parser then
-- 		return -- Skip if the parser could not be retrieved
-- 	end
--
-- 	local tree = parser:parse()[1] -- Get the first syntax tree
-- 	if not tree then
-- 		return -- Skip if parsing failed
-- 	end
--
-- 	local node_count = 0 -- Initialize node counter
-- 	local max_nodes = 5000 -- Threshold for stopping Tree-sitter
--
-- 	local function count_nodes(node)
-- 		node_count = node_count + 1
-- 		if node_count > max_nodes then
-- 			return false -- Stop counting if the limit is exceeded
-- 		end
-- 		for child in node:iter_children() do
-- 			if not count_nodes(child) then
-- 				return false
-- 			end
-- 		end
-- 		return true
-- 	end
--
-- 	-- Start counting nodes from the root
-- 	local root = tree:root()
-- 	if not count_nodes(root) then
-- 		print("Node limit exceeded. Disabling Tree-sitter for this buffer...")
-- 		parser:invalidate() -- Stop Tree-sitter
-- 	else
-- 		print("Nod not limited")
-- 	end
-- end
--
-- -- Set up an autocmd to trigger the function on BufEnter
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function()
-- 		_G.control_treesitter_on_autocmd()
-- 	end,
-- 	group = vim.api.nvim_create_augroup("TreeSitterControl", { clear = true }),
-- })

--- BufferLine
---Get the names of all current listed buffers
---@return table
local function get_current_filenames()
	local listed_buffers = vim.tbl_filter(function(bufnr)
		return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr)
	end, vim.api.nvim_list_bufs())

	return vim.tbl_map(vim.api.nvim_buf_get_name, listed_buffers)
end

---Get unique name for the current buffer
---@param filename string
---@param shorten boolean
---@return string
local function get_unique_filename(filename, shorten)
	local filenames = vim.tbl_filter(function(filename_other)
		return filename_other ~= filename
	end, get_current_filenames())

	if shorten then
		filename = vim.fn.pathshorten(filename)
		filenames = vim.tbl_map(vim.fn.pathshorten, filenames)
	end

	-- Reverse filenames in order to compare their names
	filename = string.reverse(filename)
	filenames = vim.tbl_map(string.reverse, filenames)

	local index

	-- For every other filename, compare it with the name of the current file char-by-char to
	-- find the minimum index `i` where the i-th character is different for the two filenames
	-- After doing it for every filename, get the maximum value of `i`
	if next(filenames) then
		index = math.max(table.unpack(vim.tbl_map(function(filename_other)
			for i = 1, #filename do
				-- Compare i-th character of both names until they aren't equal
				if filename:sub(i, i) ~= filename_other:sub(i, i) then
					return i
				end
			end
			return 1
		end, filenames)))
	else
		index = 1
	end

	-- Iterate backwards (since filename is reversed) until a "/" is found
	-- in order to show a valid file path
	while index <= #filename do
		if filename:sub(index, index) == "/" then
			index = index - 1
			break
		end

		index = index + 1
	end

	return string.reverse(string.sub(filename, 1, index))
end

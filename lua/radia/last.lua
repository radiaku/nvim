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

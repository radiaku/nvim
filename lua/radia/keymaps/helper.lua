-- Keymap helper functions to reduce repetitive keymap definition code
local M = {}

--- Define a single keymap with automatic opts construction
--- @param mode string|table The mode(s) for the keymap (e.g., "n", "i", "v", or {"n", "v"})
--- @param key string The key combination (e.g., "<leader>ff", "jk")
--- @param cmd string|function The command or function to execute
--- @param desc string The description for which-key and documentation
function M.map(mode, key, cmd, desc)
  -- Parameter validation
  assert(mode ~= nil, "map: mode parameter is required")
  assert(type(mode) == "string" or type(mode) == "table", 
    "map: mode must be a string or table, got " .. type(mode))
  assert(type(key) == "string", "map: key must be a string, got " .. type(key))
  assert(key ~= "", "map: key cannot be empty")
  assert(cmd ~= nil, "map: cmd parameter is required")
  assert(type(cmd) == "string" or type(cmd) == "function", 
    "map: cmd must be a string or function, got " .. type(cmd))
  assert(type(desc) == "string", "map: desc must be a string, got " .. type(desc))

  -- Construct opts with noremap and silent flags
  local opts = {
    noremap = true,
    silent = true,
    desc = desc
  }

  -- Set the keymap
  vim.keymap.set(mode, key, cmd, opts)
end

--- Define multiple keymaps for the same mode
--- @param mode string|table The mode(s) for all keymaps
--- @param mappings table Array of mapping definitions, each containing {key, cmd, desc}
function M.maps(mode, mappings)
  -- Parameter validation
  assert(mode ~= nil, "maps: mode parameter is required")
  assert(type(mode) == "string" or type(mode) == "table", 
    "maps: mode must be a string or table, got " .. type(mode))
  assert(type(mappings) == "table", "maps: mappings must be a table, got " .. type(mappings))
  assert(#mappings > 0, "maps: mappings table cannot be empty")

  -- Iterate through mappings and create each keymap
  for i, mapping in ipairs(mappings) do
    assert(type(mapping) == "table", 
      string.format("maps: mapping at index %d must be a table, got %s", i, type(mapping)))
    assert(#mapping >= 3, 
      string.format("maps: mapping at index %d must have at least 3 elements (key, cmd, desc)", i))
    
    local key = mapping[1]
    local cmd = mapping[2]
    local desc = mapping[3]
    
    -- Use the map function to create the keymap
    M.map(mode, key, cmd, desc)
  end
end

return M

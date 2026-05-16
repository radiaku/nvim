local M = {}

local legacy_validator_aliases = {
  b = "boolean",
  c = "callable",
  f = "function",
  n = "number",
  s = "string",
  t = "table",
}

local function normalize_validator(validator)
  if type(validator) == "string" then
    return legacy_validator_aliases[validator] or validator
  end

  if type(validator) == "table" then
    local normalized = {}
    for i, item in ipairs(validator) do
      normalized[i] = normalize_validator(item)
    end
    return normalized
  end

  return validator
end

local function patch_validate()
  if vim.g.radia_compat_validate_patched then
    return
  end

  local original_validate = vim.validate

  vim.validate = function(name, value, validator, optional, message)
    if validator ~= nil or type(name) ~= "table" then
      return original_validate(name, value, validator, optional, message)
    end

    local keys = vim.tbl_keys(name)
    table.sort(keys)

    for _, key in ipairs(keys) do
      local spec = name[key]
      original_validate(key, spec[1], normalize_validator(spec[2]), spec[3], spec[4])
    end
  end

  vim.g.radia_compat_validate_patched = true
end

local function flatten_legacy_list(value, result)
  if type(value) ~= "table" then
    result[#result + 1] = value
    return result
  end

  for _, item in ipairs(value) do
    flatten_legacy_list(item, result)
  end

  return result
end

local function patch_tbl_flatten()
  if vim.g.radia_compat_tbl_flatten_patched then
    return
  end

  if type(vim.iter) == "function" then
    vim.tbl_flatten = function(t)
      return vim.iter(t):flatten(math.huge):totable()
    end
  else
    vim.tbl_flatten = function(t)
      return flatten_legacy_list(t, {})
    end
  end

  vim.g.radia_compat_tbl_flatten_patched = true
end

local function patch_lsp_client(client)
  if not client or client._radia_compat_methods_patched then
    return
  end

  local methods = {
    "request",
    "request_sync",
    "notify",
    "cancel_request",
    "stop",
    "is_stopped",
    "on_attach",
    "supports_method",
  }

  local class = getmetatable(client)
  if not class then
    return
  end

  for _, method_name in ipairs(methods) do
    local method = class[method_name]
    if type(method) == "function" then
      client[method_name] = function(...)
        local first = select(1, ...)
        if first == client then
          return method(...)
        end

        return method(client, ...)
      end
    end
  end

  client._radia_compat_methods_patched = true
end

local function patch_lsp()
  if vim.g.radia_compat_lsp_patched then
    return
  end

  vim.lsp.client_is_stopped = function(client_id)
    assert(client_id, "missing client_id param")
    return vim.lsp.get_client_by_id(client_id) == nil
  end

  for _, client in ipairs(vim.lsp.get_clients()) do
    patch_lsp_client(client)
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("radia-compat-lsp", { clear = true }),
    callback = function(args)
      patch_lsp_client(vim.lsp.get_client_by_id(args.data.client_id))
    end,
  })

  vim.g.radia_compat_lsp_patched = true
end

local function extract_treesitter_range(node)
  local target = node

  if type(target) == "table" then
    target = target.node or target.tsnode or target[1]
  end

  if not target then
    return nil
  end

  local start_fn = target.start
  local end_fn = target["end_"] or target["end"]

  if type(start_fn) ~= "function" or type(end_fn) ~= "function" then
    return nil
  end

  local start_row, start_col, start_byte = start_fn(target)
  local end_row, end_col, end_byte = end_fn(target)

  if start_row == nil or end_row == nil then
    return nil
  end

  return {
    start_row,
    start_col,
    end_row,
    end_col,
    start_byte or 0,
    end_byte or 0,
  }
end

local function get_treesitter_text(node, source, metadata)
  if metadata and metadata.text then
    return metadata.text
  end

  local range = extract_treesitter_range(node)
  if not range then
    return nil
  end

  if type(source) == "number" then
    local start_row, start_col, end_row, end_col = range[1], range[2], range[3], range[4]

    if end_col == 0 then
      if start_row == end_row then
        start_col = -1
        start_row = start_row - 1
      end
      end_col = -1
      end_row = end_row - 1
    end

    local lines = vim.api.nvim_buf_get_text(source, start_row, start_col, end_row, end_col, {})
    return table.concat(lines, "\n")
  end

  if type(source) == "string" then
    return source:sub((range[5] or 0) + 1, range[6] or 0)
  end

  return nil
end

local function patch_tsnode_metatable()
  if vim.g.radia_compat_tsnode_patched then
    return
  end

  local ok, parser = pcall(vim.treesitter.get_string_parser, "x", "lua")
  if not ok or not parser then
    return
  end

  local trees = parser:parse()
  local root = trees and trees[1] and trees[1]:root() or nil
  local mt = root and debug.getmetatable(root) or nil
  if not mt then
    return
  end

  local function fallback_range(self, include_bytes)
    local range = extract_treesitter_range(self)
    if not range then
      error("Unable to compute Treesitter node range")
    end

    if include_bytes then
      return unpack(range)
    end

    return range[1], range[2], range[3], range[4]
  end

  if mt.range == nil then
    mt.range = fallback_range
  end

  if type(mt.__index) == "table" and mt.__index.range == nil then
    mt.__index.range = fallback_range
  end

  vim.g.radia_compat_tsnode_patched = true
end

local function patch_treesitter()
  if vim.g.radia_compat_treesitter_patched then
    return
  end

  patch_tsnode_metatable()

  local ts = vim.treesitter
  if not ts or type(ts.get_range) ~= "function" or type(ts.get_node_text) ~= "function" then
    return
  end

  local original_get_range = ts.get_range
  local original_get_node_text = ts.get_node_text

  ts.get_range = function(node, source, metadata)
    local ok, result = pcall(original_get_range, node, source, metadata)
    if ok then
      return result
    end

    local fallback_range = extract_treesitter_range(node)
    if fallback_range then
      return fallback_range
    end

    error(result)
  end

  ts.get_node_text = function(node, source, opts)
    local ok, result = pcall(original_get_node_text, node, source, opts)
    if ok then
      return result
    end

    local metadata = opts and opts.metadata or nil
    local fallback_text = get_treesitter_text(node, source, metadata)
    if fallback_text ~= nil then
      return fallback_text
    end

    error(result)
  end

  vim.g.radia_compat_treesitter_patched = true
end

function M.setup()
  patch_tbl_flatten()
  patch_validate()
  patch_lsp()
  patch_treesitter()
end

return M

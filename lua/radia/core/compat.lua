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

function M.setup()
  patch_validate()
  patch_lsp()
end

return M

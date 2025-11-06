-- Disable Neovim's built-in OSC52 clipboard on Termux
-- if (vim.env.PREFIX or ""):find("/com.termux/") then
--   vim.g.loaded_clipboard_provider = 1
--   -- If you previously forced clipboard use, undo it:
--   -- vim.opt.clipboard = ""  -- optional; keep if you don't need system clipboard
-- end

-- Only allow builtin OSC52 when a real TTY is present
-- if not io.stdout or not io.stdout.isatty or (io.stdout.isatty and not io.stdout:isatty()) then
--   vim.g.loaded_clipboard_provider = 1
-- end

vim.api.nvim_create_user_command("Msgs", function()
  local messages = vim.api.nvim_exec2("messages", { output = true }).output
  vim.cmd("new")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(messages, "\n"))
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
end, {})

-- Disable Neovim's built-in OSC52 clipboard on Termux
if (vim.env.PREFIX or ""):find("/com.termux/") then
  vim.g.loaded_clipboard_provider = 1
  -- If you previously forced clipboard use, undo it:
  -- vim.opt.clipboard = ""  -- optional; keep if you don't need system clipboard
end

-- Only allow builtin OSC52 when a real TTY is present
if not io.stdout or not io.stdout.isatty or (io.stdout.isatty and not io.stdout:isatty()) then
  vim.g.loaded_clipboard_provider = 1
end

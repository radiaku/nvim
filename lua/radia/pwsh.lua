-- vim.opt.shell = "pwsh"
-- vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
--
-- -- vim.opt.shellcmdflag =
-- -- 	"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
-- -- vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
-- -- vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
-- vim.opt.shellquote = ""
-- vim.opt.shellxquote = ""
--

vim.opt.shell = 'pwsh'
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText;"
vim.opt.shellxquote = ''
vim.opt.shellxescape = ''









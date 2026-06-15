return {
	'akinsho/bufferline.nvim',
	-- version = "4.9.1",
	event = "VeryLazy",
	dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local bufferline = require('bufferline')
    bufferline.setup()
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'SessionLoadPost' }, {
      callback = function()
        vim.schedule(function()
          pcall(bufferline.refresh)
        end)
      end,
    })
  end
}

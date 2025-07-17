return {
	'akinsho/bufferline.nvim',
	-- version = "4.6.1",
	requires = 'nvim-tree/nvim-web-devicons',
  config = function ()
    require('bufferline').setup()
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd('BufAdd', {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end
}

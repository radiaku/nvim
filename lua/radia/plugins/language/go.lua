return {
	"ray-x/go.nvim",
	commit = "ef38820e413e10f47d83688dee41785bd885fb2a",
	dependencies = {
		"ray-x/guihua.lua",
	},
	config = function()
		require("go").setup({
			lsp_codelens = false,
			lsp_inlay_hints = {
				enable = false,
			},
		})
	end,
	event = { "CmdlineEnter" },
	filetypes = { "go", "gomod" },
  build = function()
    if vim.fn.executable("go") == 1 then
      -- Detect Termux and disable CGO to avoid aarch64-android clang errors
      local is_termux = false
      local prefix = vim.env.PREFIX or ""
      if prefix:find("com%.termux") then
        is_termux = true
      end

      if is_termux then
        local prev_cgo = vim.env.CGO_ENABLED
        local prev_gobin = vim.env.GOBIN
        -- Install Go tools into Termux bin and disable CGO
        vim.env.GOBIN = (vim.env.PREFIX or "") .. "/bin"
        vim.env.CGO_ENABLED = "0"
        local ok, err = pcall(function()
          require("go.install").update_all_sync()
        end)
        -- Restore previous env
        vim.env.CGO_ENABLED = prev_cgo
        vim.env.GOBIN = prev_gobin
        if not ok then
          vim.notify("go.nvim tool install failed (Termux): " .. tostring(err), vim.log.levels.WARN)
        end
      else
        require("go.install").update_all_sync()
      end
    else
      vim.notify("Go is not installed or not in PATH", vim.log.levels.WARN)
    end
  end,
}

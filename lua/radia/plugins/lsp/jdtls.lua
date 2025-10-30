return {
    "mfussenegger/nvim-jdtls",
    -- Completely disable on Termux so Lazy won't install/download this plugin
    enabled = function()
        local prefix = vim.env.PREFIX or ""
        return not prefix:find("com%.termux")
    end,
    ft = { "java" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
		local ok, jdtls = pcall(require, "jdtls")
		if not ok then
			return
		end

		local util = require("lspconfig/util")
		local home = vim.fn.expand("~")
		local prefix = vim.env.PREFIX or ""
		local is_termux = prefix:find("com%.termux") ~= nil

		-- Where JDTLS is installed. Prefer Mason’s package, then JDTLS_HOME, then ~/.local/share/jdtls
		local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
		local jdtls_home = vim.env.JDTLS_HOME
		if not jdtls_home or jdtls_home == "" then
			if vim.fn.isdirectory(mason_pkg) == 1 then
				jdtls_home = mason_pkg
			else
				jdtls_home = home .. "/.local/share/jdtls"
			end
		end

		-- Workspace directory per project
		local workspace_root = home .. "/.cache/jdtls/workspace"
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = workspace_root .. "/" .. project_name

		-- Build the launch command
		local cmd
		local script = jdtls_home .. "/bin/jdtls"
		if vim.fn.filereadable(script) == 1 or vim.fn.executable(script) == 1 then
			cmd = { script }
		else
			local launcher = vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar")
			local config_dir
			if vim.fn.has("mac") == 1 then
				config_dir = jdtls_home .. "/config_mac"
			else
				config_dir = jdtls_home .. "/config_linux"
			end
			if launcher ~= nil and launcher ~= "" then
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					launcher,
					"-configuration",
					config_dir,
					"-data",
					workspace_dir,
				}
			end
		end

		if not cmd then
			vim.notify(
				"jdtls not found under " .. jdtls_home .. ". Set JDTLS_HOME or follow installertermux.md.",
				vim.log.levels.WARN
			)
			return
		end

		local root_dir = util.root_pattern("pom.xml", "build.gradle", "settings.gradle", ".git")(vim.fn.getcwd())
			or vim.fn.getcwd()

		jdtls.start_or_attach({
			cmd = cmd,
			root_dir = root_dir,
			workspace_folder = workspace_dir,
			settings = {
				java = {
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" },
					configuration = { updateBuildConfiguration = "interactive" },
				},
			},
			init_options = {
				bundles = {},
			},
		})
	end,
}


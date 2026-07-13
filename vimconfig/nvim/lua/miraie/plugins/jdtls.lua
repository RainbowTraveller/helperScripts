-- Helper function to safely merge options/configs if LazyVim's global is missing
local function extend_or_override(config, custom)
	if type(custom) == "function" then
		custom(config)
	elseif type(custom) == "table" then
		config = vim.tbl_deep_extend("force", config, custom)
	end
	return config
end

return {
	"mfussenegger/nvim-jdtls",
	dependencies = { "folke/which-key.nvim", "neovim/nvim-lspconfig" },
	ft = { "java" },
	opts = function()
		return {
			-- Fixed path: changed 'server_configurations' to 'configs'
			root_dir = require("lspconfig.configs.jdtls").default_config.root_dir,
			project_name = function(root_dir) return root_dir and vim.fs.basename(root_dir) end,
			jdtls_config_dir = function(project_name) return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config" end,
			jdtls_workspace_dir = function(project_name) return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace" end,
			cmd = { vim.fn.exepath("jdtls") },
			full_cmd = function(opts)
				local fname = vim.api.nvim_buf_get_name(0)
				local root_dir = opts.root_dir(fname)
				local project_name = opts.project_name(root_dir)
				local cmd = vim.deepcopy(opts.cmd)
				if project_name then
					vim.list_extend(cmd, { "-configuration", opts.jdtls_config_dir(project_name), "-data", opts.jdtls_workspace_dir(project_name) })
				end
				return cmd
			end,
			dap = { hotcodereplace = "auto", config_overrides = {} },
			dap_main = {},
			test = true,
		}
	end,
	config = function()
		-- Handle LazyVim options mapping safely
		local opts = (type(LazyVim) == "table" and LazyVim.opts("nvim-jdtls")) or {}
		if next(opts) == nil then
			local plugin = require("lazy.core.config").plugins["nvim-jdtls"]
			opts = require("lazy.core.plugin").values(plugin, "opts", false)
		end

		local mason_registry = require("mason-registry")
		local bundles = {}
		local has_dap = (type(LazyVim) == "table" and LazyVim.has("nvim-dap")) or pcall(require, "dap")
		
		if opts.dap and has_dap and mason_registry.is_installed("java-debug-adapter") then
			local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
			local java_dbg_path = java_dbg_pkg:get_install_path()
			local jar_patterns = { java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar" }
			if opts.test and mason_registry.is_installed("java-test") then
				local java_test_pkg = mason_registry.get_package("java-test")
				local java_test_path = java_test_pkg:get_install_path()
				vim.list_extend(jar_patterns, { java_test_path .. "/extension/server/*.jar" })
			end
			for _, jar_pattern in ipairs(jar_patterns) do
				for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
					table.insert(bundles, bundle)
				end
			end
		end

		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)
			local has_cmp = (type(LazyVim) == "table" and LazyVim.has("cmp-nvim-lsp")) or pcall(require, "cmp_nvim_lsp")
			local config = extend_or_override({
				cmd = opts.full_cmd(opts),
				root_dir = opts.root_dir(fname),
				init_options = { bundles = bundles },
				capabilities = has_cmp and require("cmp_nvim_lsp").default_capabilities() or nil,
			}, opts.jdtls)
			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", { pattern = { "java" }, callback = attach_jdtls })
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					local wk = require("which-key")
					wk.add({
						{ "<leader>cx", group = "extract" },
						{ "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable", mode = "n", buffer = args.buf },
						{ "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant", mode = "n", buffer = args.buf },
						{ "gs", require("jdtls").super_implementation, desc = "Goto Super", mode = "n", buffer = args.buf },
						{ "gS", require("jdtls.tests").goto_subjects, desc = "Goto Subjects", mode = "n", buffer = args.buf },
						{ "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports", mode = "n", buffer = args.buf },
						{ "<leader>c", group = "code", mode = "v" },
						{ "<leader>cxm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], desc = "Extract Method", mode = "v", buffer = args.buf },
					})
					if opts.dap and has_dap and mason_registry.is_installed("java-debug-adapter") then
						require("jdtls").setup_dap(opts.dap)
						require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
						if opts.test and mason_registry.is_installed("java-test") then
							wk.add({
								{ "<leader>t", group = "test" },
								{ "<leader>tt", require("jdtls.dap").test_class, desc = "Run All Test", mode = "n", buffer = args.buf },
								{ "<leader>tr", require("jdtls.dap").test_nearest_method, desc = "Run Nearest Test", mode = "n", buffer = args.buf },
								{ "<leader>tT", require("jdtls.dap").pick_test, desc = "Run Test", mode = "n", buffer = args.buf },
							})
						end
					end
					if opts.on_attach then opts.on_attach(args) end
				end
			end,
		})
		if vim.bo.filetype == "java" then attach_jdtls() end
	end,
}

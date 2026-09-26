return {
	-- PLUGIN DECLARATION AND DEPENDENCIES SECTION
	-- This section registers `nvim-lspconfig` as the primary orchestration engine and downloads
	-- complementary package managers needed to download, verify, and attach language servers.
	"neovim/nvim-lspconfig",
	dependencies = {
		-- `mason.nvim` acts as a package manager inside Neovim. It downloads, unpacks, and manages
		-- binary executables (like language servers, linters, or formatters) into `~/.local/share/nvim/mason`.
		"williamboman/mason.nvim",

		-- `mason-lspconfig.nvim` acts as a bridging layer between Mason's binaries and nvim-lspconfig.
		-- It translates native lspconfig server names (e.g., `lua_ls`) into Mason package names (e.g., `lua-language-server`).
		"williamboman/mason-lspconfig.nvim",

		-- `mason-tool-installer.nvim` automates your setup. Instead of manually running `:MasonInstall` on
		-- a new machine, this plugin automatically verifies and installs a declared list of tools in the background.
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- `fidget.nvim` captures background communications from your active LSPs (like project indexing or compilation)
		-- and provides a clean, unobtrusive visual progress notification spinner in the bottom right corner of your screen.
		{ "j-hui/fidget.nvim", opts = {} },

		-- `cmp-nvim-lsp` acts as a data pipeline feeding language-server semantic tokens into your `nvim-cmp` menu.
		"hrsh7th/cmp-nvim-lsp",
	},

	-- CONTEXTUAL BRIEF: WHAT IS AN LSP?
	-- The Language Server Protocol (LSP) decouples language intelligence from the editor.
	-- External binaries (like `gopls` or `pyright`) analyze files independently and communicate
	-- structural details back to the client (Neovim) over JSON-RPC. Neovim handles UI hooks (jumps/menus),
	-- while the external tool performs heavy language diagnostics.

	-- CORE CONFIGURATION EXECUTION BLOCK
	-- This block executes automatically when your plugin manager initializes `nvim-lspconfig`.
	config = function()
		-- SECTION: KEYMAPS & LSP BUFFER ATTACHMENT
		-- Sets up definitions, documentation hover, rename, and code action keybindings whenever a language
		-- server successfully attaches itself to an active text buffer.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to Definition" })
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to Declaration" })
				vim.keymap.set(
					"n",
					"gi",
					vim.lsp.buf.implementation,
					{ buffer = ev.buf, desc = "Go to Implementation" }
				)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to References" })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover Documentation" })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
				vim.keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					{ buffer = ev.buf, desc = "Code Action" }
				)
			end,
		})

		-- SECTION: ENHANCING NEOVIM CAPABILITIES
		-- Here, we fetch Neovim's baseline capabilities (`make_client_capabilities`), then deep-merge them with
		-- structural definitions provided by `cmp_nvim_lsp`. This broadcast-ready table tells backend LSPs:
		-- "Hey, I can render snippet expansions and complex popup menus, so send me all advanced autocomplete metadata!"
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local lspconfig = require("lspconfig")

		-- SECTION: DYNAMIC SERVER REGISTER (SCALABLE ARCHITECTURE)
		-- Instead of hardcoding monolithic server configs in this file, we declare our desired active servers
		-- and dynamically ingest their data options from standalone files inside `lua/miraie/lsp/<server_name>.lua`.
		local server_names = { "gopls", "lua_ls", "pyright", "markdown_oxide", "angularls" }
		local servers = {}

		for _, name in ipairs(server_names) do
			local has_custom_opts, custom_opts = pcall(require, "miraie.lsp." .. name)
			if has_custom_opts then
				servers[name] = custom_opts
			else
				servers[name] = {}
			end
		end

		-- SECTION: MASON AND AUTOMATED TOOL INSTALLATION
		-- Initializes Mason's directory tracking and hands our server index to `mason-tool-installer`.
		require("mason").setup()

		-- Extract keys from our servers dictionary to automatically pass to the package installer
		local ensure_installed = vim.tbl_keys(servers)

		-- Extends the automated installation array to include binaries that aren't strict language servers,
		-- but are crucial complementary developer utilities (like standalone syntax formatters).
		vim.list_extend(ensure_installed, {
			"stylua", -- External CLI tool wrapper used to aggressively format and pretty-print raw Lua files.
		})

		-- Hands the compiled list over to `mason-tool-installer` to download missing tools in the background.
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- SECTION: MASON-LSPCONFIG BRIDGE INITIALIZATION
		-- Iterates through our dynamically loaded server table, merges our autocomplete `capabilities`,
		-- and passes options directly into `lspconfig[server_name].setup()` to launch and monitor active file events.
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server_opts = servers[server_name] or {}
					server_opts.capabilities =
						vim.tbl_deep_extend("force", {}, capabilities or {}, server_opts.capabilities or {})
					lspconfig[server_name].setup(server_opts)
				end,
			},
		})
	end,
}

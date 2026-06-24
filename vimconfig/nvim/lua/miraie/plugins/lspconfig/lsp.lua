return {
	-- PLUGIN DECLARATION AND DEPENDENCIES SECTION
	-- This section registers `nvim-lspconfig` as the primary plugin and downloads all the
	-- complementary packages needed to manage, install, and interface with your language servers.
	"neovim/nvim-lspconfig",
	dependencies = {
		-- `mason.nvim` acts as a package manager inside Neovim. It downloads, unpacks, and manages
		-- binary executables (like language servers, linters, or formatters) into an isolated internal path (`~/.local/share/nvim/mason`).
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

		-- Autocompletion Engine Components (nvim-cmp ecosystem):
		-- `nvim-cmp` is the core visual engine framework that presents popup autocomplete menus while typing.
		{ "hrsh7th/nvim-cmp" },

		-- `cmp-nvim-lsp` acts as a data pipeline feeding language-server semantic tokens into your `nvim-cmp` menu.
		{ "hrsh7th/cmp-nvim-lsp" },

		-- `LuaSnip` is the execution engine handling code snippet expansions (e.g. generating a whole loop template).
		{ "L3MON4D3/LuaSnip" },

		-- `friendly-snippets` provides a massive pre-packaged collection of boilerplate snippets for dozens of languages.
		"rafamadriz/friendly-snippets",

		-- Code completion source modules feeding specific data back into the main `nvim-cmp` menu:
		{ "hrsh7th/cmp-buffer" }, -- Scans words in the active file buffer to provide rapid contextual text suggestions.
		{ "hrsh7th/cmp-path" }, -- Detects and autocompletes file system directory paths (e.g. typing `./src/com...`).
		{ "hrsh7th/cmp-cmdline" }, -- Takes over Neovim's `:` command bar to provide search or command autocomplete suggestions.
		{ "saadparwaiz1/cmp_luasnip" }, -- Pipelines snippet definitions into the main autocompletion popup list.
	},

	-- CONTEXTUAL BRIEF: WHAT IS AN LSP?
	-- The Language Server Protocol (LSP) decouples language intelligence from the editor.
	-- External binaries (like `gopls` or `pyright`) analyze files independently and communicate
	-- structural details back to the client (Neovim) over JSON-RPC. Neovim handles UI hooks (jumps/menus),
	-- while the external tool performs heavy language diagnostics.

	-- CORE CONFIGURATION EXECUTION BLOCK
	-- This block executes automatically when your plugin manager initializes `nvim-lspconfig`.
	config = function()
		-- SECTION: ENHANCING NEOVIM CAPABILITIES
		-- Out-of-the-box, Neovim's default LSP client supports standard protocol features.
		-- However, adding complex autocomplete plugins like `nvim-cmp` extends what our editor can process.
		-- Here, we fetch Neovim's baseline features (`make_client_capabilities`), then deep-merge them with
		-- structural definitions provided by `cmp_nvim_lsp`. This broadcast-ready table tells backend LSPs:
		-- "Hey, I can render snippet expansions and complex popup menus, so send me all advanced autocomplete metadata!"
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Importing utility libraries used to assist configuration rules below.
		local util = require("lspconfig/util")
		local cmp = require("cmp")

		-- SECTION: DEFINING TARGET SERVER OPTIONS (DATA ONLY)
		-- This is a clean Lua dictionary defining your personalized preferences for specific language servers.
		-- Important: Neovim 0.12 completely splits data from activation. No actual code runs inside this block;
		-- it is used strictly to build out parameters that will be ingested later by the native engine.
		local servers = {
			-- Go Language Server (`gopls`) Specifications:
			gopls = {
				-- Explicitly calls the executable binary and tells it to spin up an internal listening process.
				cmd = { "gopls", "serve" },
				-- Dictates which active file buffers this server should automatically attach itself to.
				filetypes = { "go", "gomod" },
				-- Root directory matching rules. It looks upward from your active file until it hits a `go.mod`
				-- or `.git` directory to determine where your project starts, anchoring its codebase diagnostics.
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				-- Deeply nested properties passed directly to the Go executable binary to alter behavior.
				settings = {
					gopls = {
						analyses = {
							unusedparams = true, -- Flags warnings if a declared function argument isn't actively read.
						},
						staticcheck = true, -- Inherits robust open-source Go static analysis rules to flag edge bugs.
					},
				},
			},

			-- Markdown Oxide Specifications:
			markdown_oxide = {
				filetypes = { "markdown" }, -- Scans markdown text to manage internal wiki links and cross-references.
			},

			-- Python Server (`pyright`) Specifications:
			pyright = {
				settings = {
					pyright = {
						analysis = {
							useLibraryCodeForTypes = true, -- Automatically parses downloaded external modules (pip files) to generate type autocomplete hints.
						},
					},
				},
			},

			-- Lua Language Server (`lua_ls`) Specifications:
			lua_ls = {
				filetypes = { "lua" },
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace", -- Instantly drops complete function parameter signatures when selecting autocomplete names.
						},
					},
				},
			},
		}

		-- SECTION: COMMAND LINE INTERFACE (CMDLINE) AUTOCOMPLETE
		-- These modules attach your autocomplete window directly to Neovim UI interaction lanes outside text files.

		-- Hooking into the `/` search lane. Typing a search query pulls immediate visual matches out of active text words.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Hooking into the `:` terminal command lane. Autocompletes commands or disk file structures.
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" }, -- Autocompletes folder structures.
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" }, -- Blacklists scary commands to avoid spamming the autocomplete popups.
					},
				},
			}),
		})

		-- SECTION: THE NEVIM 0.12 NATIVE SERVER INITIALIZATION SEQUENCE
		-- This loop replaces the deprecated `require('lspconfig')[server].setup()` frameworks.
		-- It iterates over our configuration data table and natively feeds it into Neovim's modernized engine cores.
		for server_name, server_opts in pairs(servers) do
			-- Safely injects your complex autocompletion capability map into every language server's block options.
			-- This guarantees that whether it is Go or Python, every server knows how to properly talk back to `nvim-cmp`.
			server_opts.capabilities =
				vim.tbl_deep_extend("force", {}, capabilities or {}, server_opts.capabilities or {})

			-- `vim.lsp.config()` registers the options table with Neovim's native registry for that specific server.
			vim.lsp.config(server_name, server_opts)

			-- `vim.lsp.enable()` tells Neovim to instantly start monitoring active file events.
			-- As soon as you open a matching filetype (like a `.go` file), Neovim automatically spawns
			-- the underlying binary and hooks it to your editing screen buffer.
			vim.lsp.enable(server_name)
		end

		-- SECTION: MASON AND COMPLEMENTARY AUTOMATED INSTALLATION CONFIGURATION
		-- This sequence ensures that all of your declared servers actually exist as binaries on your machine.

		-- Initializes Mason's low-level directory variables and prepares internal tracking configurations.
		require("mason").setup()

		-- Pulls the text keys directly out of your `servers` data map to build an index array of what packages to fetch.
		local ensure_installed = vim.tbl_keys(servers or {})

		-- Extends the automated installation array to include binaries that aren't strict language servers,
		-- but are crucial complementary developer utilities (like standalone syntax formatters).
		vim.list_extend(ensure_installed, {
			"stylua", -- External CLI tool wrapper used to aggressively format and pretty-print raw Lua files.
		})

		-- Hands the compiled list over to `mason-tool-installer`. It compares what is written against what is
		-- physically saved on your hard drive, safely downloading anything missing in the background.
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Ingests our keys to map native lspconfig settings into Mason system handlers safely.
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
		})
	end,
}

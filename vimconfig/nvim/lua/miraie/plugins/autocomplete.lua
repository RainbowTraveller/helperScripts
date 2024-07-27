return {
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets
					-- This step is not supported in many windows environments
					-- Remove the below condition to re-enable on windows
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
			"saadparwaiz1/cmp_luasnip",
			-- If you want to add a bunch of pre-configured snippets,
			--    you can use this plugin to help you. It even has snippets
			--    for various frameworks/libraries/etc. but you will have to
			--    set up the ones that are useful for you.
			"rafamadriz/friendly-snippets",
			"hrsh7th/vim-vsnip", -- source for nvim-cmp : code snippets

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp", -- source for nvim-cmp  : nvim's built in language server client
			"hrsh7th/cmp-nvim-lua", -- source for nvim-cmp  : nvim's lua API
			"hrsh7th/cmp-nvim-lsp-signature-help", -- source for nvim-cmp : source for displaying function signature with current parameter emphasized
			"hrsh7th/cmp-buffer", -- source for nvim-cmp : buffer words
			"hrsh7th/cmp-path", -- source for nvim-cmp : filesystem paths
			"hrsh7th/cmp-cmdline", -- source for nvim-cmp : filesystem paths
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				-- completeopt is used to manage code suggestions
				-- menuone: show popup even when there is only one suggestion
				-- noinsert: Only insert text when selection is confirmed
				-- noselect: force us to select one from the suggestions
				completion = { completeopt = "menu,menuone,noinsert,noselect,preview" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),

				-- Add borders to the windows
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				-- add formating of the different sources
				formatting = {
					expandable_indicator = true,
					fields = { "menu", "abbr", "kind" },
					format = function(entry, item)
						local menu_icon = {
							nvim_lsp = "λ",
							vsnip = "⋗",
							buffer = "b",
							path = "p",
						}
						item.menu = menu_icon[entry.source.name]
						return item
					end,
				},

				sources = {
					{ name = "nvim_lsp", keyword_length = 3 },
					{ name = "luasnip" },
					{ name = "nvim_lua", keyword_length = 2 },
					{ name = "nvim_lsp_signature_help" },
					{ name = "buffer", keyword_length = 2 },
					{ name = "path" },
					{ name = "cmdline", keyword_length = 4 },
				},
			})
		end,
	},
}

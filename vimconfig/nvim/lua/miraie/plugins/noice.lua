return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = { -- add any options here
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		-- Configure nvim-notify for bright, noticeable notifications
		require("notify").setup({
			background_colour = "#000000",
			fps = 60,
			-- =========================================================================
			-- --> IMPROVED: UPDATED ALL GLYPH ASSETS FOR NERD FONTS V3 COMPATIBILITY
			-- =========================================================================
			icons = {
				DEBUG = " ",
				ERROR = " ",
				INFO = " ",
				TRACE = "✎ ",
				WARN = " ",
			},
			level = 2,
			minimum_width = 50,
			render = "default",
			stages = "fade_in_slide_out",
			timeout = 3000,
			top_down = true,
		})

		-- =========================================================================
		-- --> CHANGED: REMOVED MANUAL 'vim.notify = require("notify")' TO PREVENT
		--              RACE CONDITIONS. NOICE HANDLES THIS LINKING AUTOMATICALLY.
		-- =========================================================================

		require("noice").setup({
			lsp = {
				override = {
					-- =========================================================================
					-- --> CHANGED: REMOVED DEPRECATED 'vim.lsp.util.convert_input...' AND
					--              'stylize_markdown' STRINGS TO PREVENT NVIM 0.12 WARNINGS.
					-- =========================================================================
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = false, -- Keeps search away from the bottom-left corner
				command_palette = false, -- DISABLED: Safely prevents overriding our custom positioning layout below
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
			cmdline = {
				enabled = true,
				view = "cmdline_popup", -- FORCES the core layout engine to use our custom popup view below
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "nvim" },
					-- =========================================================================
					-- --> IMPROVED: ADDED EXPLICIT VIEW LOCKS AND MODERN ICONS TO PREVENT DRIFT
					-- =========================================================================
					search_down = {
						view = "cmdline_popup",
						kind = "search",
						pattern = "^/",
						icon = " ",
						lang = "regex",
					},
					search_up = {
						view = "cmdline_popup",
						kind = "search",
						pattern = "^%?",
						icon = " ",
						lang = "regex",
					},
					filter = { view = "cmdline_popup", pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = {
						view = "cmdline_popup",
						pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
						icon = "",
						lang = "lua",
					},
					help = { view = "cmdline_popup", pattern = "^:%s*he?l?p?%s+", icon = " " },
					input = { view = "cmdline_input", icon = "   " },
				},
			},
			routes = {
				{
					filter = { event = "notify", find = "git repository" },
					view = "notify",
				},
				{
					filter = { event = "notify" },
					view = "mini",
				},
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "written" },
							{ find = "lines, " },
							{ find = "change" },
							{ find = "more lines" },
							{ find = "fewer lines" },
						},
					},
					opts = { skip = true },
				},
			},
			views = {
				notify = {
					backend = "notify",
					level = "info",
					replace = true,
					merge = false,
				},
				-- CUSTOM PIPELINE WINDOW DEFINITIONS: Absolute dead-center layouts
				cmdline_popup = {
					backend = "popup",
					relative = "editor",
					position = {
						row = "50%",
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = "56%", -- Positioned slightly under row 50% to make drop-downs look natural
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					},
				},
			},
		})
	end,
}

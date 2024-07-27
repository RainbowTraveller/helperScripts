local name = {

	[[]],
	[[]],
	[[                                  __						]],
	[[     ___     ___    ___   __  __ /\_\    ___ ___		    ]],
	[[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\	    ]],
	[[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \	    ]],
	[[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\	    ]],
	[[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/	    ]],
	[[															]],
	[[					  __				   __				]],
	[[			___ ___	 /\_\   _  _	 __   /\_\    ___       ]],
	[[		   / __` __`\\/\ \ /\`'__\ /'__`\ \/\ \  / __`\     ]],
	[[		  /\ \/\ \/\ \\ \ \\ \ \_//\ \L\.\_\ \ \/\  __/     ]],
	[[		  \ \_\ \_\ \_\\ \_\\ \_\ \ \__/.\_\\ \_\ \____\    ]],
	[[		   \/_/\/_/\/_/ \/_/ \/_/  \/__/\/_/ \/_/\/____/    ]],
	[[		                                                    ]],
	[[]],
	[[]],
}
return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		dashboard.section.buttons.val = {
			dashboard.button("r", " Restore session", "<cmd>SessionRestore<CR>"),
			dashboard.button(
				"s",
				"ﴬ Find session",
				'<cmd>lua require("auto-session.session-lens").search_session()<CR>'
			),
			dashboard.button("f", " Find file", "<cmd>Telescope find_files<CR>"),
			dashboard.button("t", " Find text", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("o", " Recently opened files", "<cmd>Telescope oldfiles<CR>"),
			dashboard.button("u", " Update Plugins", "<cmd>Lazy sync<CR>"),
			dashboard.button("q", " Quit", ":qa<CR>"),
		}
		dashboard.section.header.val = name
		dashboard.section.footer.val = " Milind Vaidya"
		alpha.setup(dashboard.opts)
		vim.keymap.set("n", "<leader>;", ":Alpha<CR>", { desc = "Toggle Alpha", silent = true })
	end,
}

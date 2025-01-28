return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = {
			---@class snacks.dashboard.Config
			---@field enabled? boolean
			---@field sections snacks.dashboard.Section
			---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>

			enabled = true,
			width = 50,
			-- row = 10, -- dashboard position. nil for center
			-- col = 70, -- dashboard position. nil for center
			preset = {
				header = [[

	  __				   __
		___ ___	 /\_\   _  _	 __   /\_\    ___
		   / __` __`\\/\ \ /\`'__\ /'__`\ \/\ \  / __`\
		  /\ \/\ \/\ \\ \ \\ \ \_//\ \L\.\_\ \ \/\  __/
		  \ \_\ \_\ \_\\ \_\\ \_\ \ \__/.\_\\ \_\ \____\
		   \/_/\/_/\/_/ \/_/ \/_/  \/__/\/_/ \/_/\/____/]],
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "recent_files", icon = " ", title = "Recent Files", indent = 2, padding = 1 },
				{ section = "projects", icon = " ", title = "Projects", indent = 2, padding = 1 },
				{
					section = "terminal",
					icon = " ",
					title = "Git Status",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{
					pane = 2,
					section = "terminal",
					cmd = "ascii-image-converter ~/Downloads/MiloAvatar.JPG -C -b --dither",
					random = 10,
					indent = 4,
					height = 40,
					width = 60,
				},
				{ section = "startup" },
			},
		},
	},
	--   bigfile = { enabled = true },
	indent = { enabled = true },
	--   input = { enabled = true },
	notifier = { enabled = true },
	--   quickfile = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	styles = {
		notification = {
			wo = { wrap = true }, -- Wrap notifications
		},
	},
}

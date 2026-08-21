return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			width = 50,
			preset = {
				header = [[
			      __
	     ___     ___    ___   __  __ /\_\    ___ ___
	    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\
	   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \
	   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
	    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/


		  __		           __
		    ___ __   /\_\   _  _     __   /\_\    ___
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
					cmd = "ascii-image-converter ~/Downloads/Penguin.jpg -C -b --dither",
					random = 10,
					indent = 4,
					height = 40,
					width = 60,
				},
				{ section = "startup" },
			},
		},
		picker = {
			-- Permanently drop these folders from ever entering your snacks pickers
			exclude = {
				"**/.git/*",
				"**/node_modules/*",
				"**/dist/*",
				"**/.cache/*",
			},
		},
		sources = {
			grep = {
				hidden = true,
				ignored = true, -- Bypasses gitignore only during a live grep
			},
		},
		indent = { enabled = true },
		lazygit = {
			configure = true,
			-- extra configuration for lazygit that will be merged with the default
			-- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
			-- you need to double quote it: `"\"test\""`
			---@class snacks.lazygit.Config: snacks.terminal.Opts
			---@field args? string[]
			---@field theme? snacks.lazygit.Theme
			config = {
				os = { editPreset = "nvim-remote" },
				gui = {
					-- set to an empty string "" to disable icons
					nerdFontsVersion = "3",
				},
			},
			theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
			-- Theme for lazygit
			theme = {
				[241] = { fg = "Special" },
				activeBorderColor = { fg = "MatchParen", bold = true },
				cherryPickedCommitBgColor = { fg = "Identifier" },
				cherryPickedCommitFgColor = { fg = "Function" },
				defaultFgColor = { fg = "Normal" },
				inactiveBorderColor = { fg = "FloatBorder" },
				optionsTextColor = { fg = "Function" },
				searchingActiveBorderColor = { fg = "MatchParen", bold = true },
				selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
				unstagedChangesColor = { fg = "DiagnosticError" },
			},
			win = {
				style = "terminal",
			},
		},
		notifier = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {
			notification = {
				wo = { wrap = true }, -- Wrap notifications
			},
		},
	},

	keys = {
		{
			"<leader>sg",
			function()
				local is_git = (vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1] or "") == "true"
				if is_git then
					Snacks.picker.files({ git_only = true })
				else
					vim.notify("⚠ Not a git repository", vim.log.levels.WARN)
				end
			end,
			desc = "[S]earch [G]it Files",
		},
		{
			"<leader>sf",
			function()
				Snacks.picker.files({ title = "List files in your current working directory" })
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.buffers({ title = "Open Buffers" })
			end,
			desc = "[S]earch [B]uffers",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help({ title = "Help Tags" })
			end,
			desc = "[S]earch [H]elp",
		},

		-- Grep and word searches
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word({
					title = "Search string under cursor in your current working directory...",
				})
			end,
			desc = "[S]earch current [W]ord",
			mode = { "n", "x" },
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.grep({
					title = "Search as you type a string in your current working directory...",
				})
			end,
			desc = "[S]earch by [L]ive grep",
		},

		-- Advanced context-aware fuzzy searching
		{
			"<leader>/",
			function()
				Snacks.picker.lines({ layout = "select", title = "Fuzzily search in current buffer" })
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>s/",
			function()
				Snacks.picker.grep({
					buffers = true,
					title = "Live Grep in Open Files",
				})
			end,
			desc = "[S]earch [/] in Open Files",
		},

		-- Snacks picker tracking
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics({
					title = "Search diagnostics in your current working directory...",
				})
			end,
			desc = "[S]earch [D]iagnostics",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps({ title = "Keymaps" })
			end,
			desc = "[S]earch [K]eymaps",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.pickers({ title = "All Snacks pickers" })
			end,
			desc = "[S]earch [S]elect Picker",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.resume({ title = "Resume last search" })
			end,
			desc = "[S]earch [R]esume",
		},
		{
			"<leader>s.",
			function()
				Snacks.picker.recent({ title = "Search Recent Files" })
			end,
			desc = "[S]earch Recent Files",
		},

		-- Nvim global config lookup shortcut
		{
			"<leader>sc",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config"), title = "Search Neovim config files" })
			end,
			desc = "[S]earch Neovim [C]onfig files",
		},

		-- Lazygit
		{
			"<leader>gg",
			function()
				Snacks.lazygit({ title = "Open lazygit in your current working directory..." })
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log({ title = "Open lazygit log in your current working directory..." })
			end,
			desc = "Lazygit Log",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_log_file({ title = "Open lazygit log for current file..." })
			end,
			desc = "Lazygit Log for Current File",
		},

		-- Git Pickers
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches({ title = "Git Branches" })
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gs", -- This maps smoothly now since lazygit status uses uppercase S
			function()
				Snacks.picker.git_status({ title = "Git Status" })
			end,
			desc = "Git Status",
		},
		{
			"<leader>gc",
			function()
				Snacks.picker.git_log({ title = "Git Commits" })
			end,
			desc = "Git Commits",
		},
	},
}

return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		},
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-dap.nvim",
		-- {
		-- 	-- If encountering errors, see telescope-fzf-native README for install instructions
		-- 	"nvim-telescope/telescope-fzf-native.nvim",
		--
		-- 	-- `build` is used to run some command when the plugin is installed/updated.
		-- 	-- This is only run then, not every time Neovim starts up.
		-- 	build = "make",
		--
		-- 	-- `cond` is a condition used to determine whether this plugin should be
		-- 	-- installed and loaded.
		-- 	cond = function()
		-- 		return vim.fn.executable("make") == 1
		-- 	end,
		-- },
		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},

	-- Telescope is a fuzzy finder that comes with a lot of different things that
	-- it can fuzzy find! It's more than just a "file finder", it can search
	-- many different aspects of Neovim, your workspace, LSP, and more!
	--
	-- The easiest way to use telescope, is to start by doing something like:
	--  :Telescope help_tags
	--
	-- After running this command, a window will open up and you're able to
	-- type in the prompt window. You'll see a list of help_tags options and
	-- a corresponding preview of the help.
	--
	-- Two important keymaps to use while in telescope are:
	--  - Insert mode: <c-/>
	--  - Normal mode: ?
	--
	-- This opens a window that shows you all of the keymaps for the current
	-- telescope picker. This is really useful to discover what Telescope can
	-- do as well as how to actually do it!

	-- [[ Configure Telescope ]]
	-- See `:help telescope` and `:help telescope.setup()`
	config = function()
		-- You can put your default mappings / updates / etc. in here
		--  All the info you're looking for is in `:help telescope.setup()`
		--
		-- defaults = {
		--   mappings = {
		--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
		--   },
		-- },
		-- pickers = {}

		local fb_actions = require("telescope").extensions.file_browser.actions
		require("telescope").setup({
			-- pickers = {
			-- 	find_files = {
			-- 		mappings = {
			-- 			n = {
			-- 				["cd"] = function(prompt_bufnr)
			-- 					local selection = require("telescope.actions.state").get_selected_entry()
			-- 					local dir = vim.fn.fnamemodify(selection.path, ":p:h")
			-- 					require("telescope.actions").close(prompt_bufnr)
			-- 					-- Depending on what you want put `cd`, `lcd`, `tcd`
			-- 					vim.cmd(string.format("silent lcd %s", dir))
			-- 				end,
			-- 			},
			-- 		},
			-- 	},
			-- },
			extensions = {
				["fzf"] = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						-- even more opts
					}),
				},
				["file_browser"] = {
					theme = "ivy",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					mappings = {
						["i"] = {
							["<C-H>"] = fb_actions.goto_home_dir,
						},
						["n"] = {
							["<C-H>"] = fb_actions.goto_home_dir,
							["cd"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								local dir = vim.fn.fnamemodify(selection.path, ":p:h")
								require("telescope.actions").close(prompt_bufnr)
								-- Depending on what you want put `cd`, `lcd`, `tcd`
								vim.cmd(string.format("silent lcd %s", dir))
							end,
						},
					},
				},
			},
		})

		-- Enable telescope extensions, if they are installed
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("metals")
		require("telescope").load_extension("noice")
		require("telescope").load_extension("file_browser")

		-- DAP integration
		require("telescope").load_extension("dap")
		local builtin = require("telescope.builtin")

		-- find files using telescope build in functionality which fuzzy finds the files in the current directory
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })

		-- open file_browser with the path of the current buffer which is based on the extension
		-- vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
		vim.keymap.set("n", "<space>fb", function()
			require("telescope").extensions.file_browser.file_browser()
		end)

		-- find git files ( when inside the repository )
		vim.keymap.set("n", "<leader>sv", builtin.git_files, { desc = "[S]earch Git [V]ersion  Control Files" })

		-- Search fuzzily amongst open buffers. Buffer is nothing but open file, can be multiple ones
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch open [B]uffers" })

		-- Help search the nvim help topics
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

		-- Searches for the word entered in your current working directory
		-- vim.keymap.set("n", "<leader>sw", function()
		-- 	builtin.grep_string({ search = vim.fn.input(" Grep > ") })
		-- end, { desc = "[S]earch [W]ord in current directory" })

		vim.keymap.set("n", "<leader>sw", function()
			builtin.grep_string()
		end, { desc = "[S]earch [W]ord in current directory" })

		--  Search in the open buffers ( needs ripgrep to work )
		vim.keymap.set("n", "<leader>sg", function()
			builtin.live_grep({ prompt_title = "Find string in open buffers...", grep_open_files = true })
		end, { desc = "[S]earch by [G]rep interactively" })

		-- Lists Normal mode keymappings, runs the selected keymap on <cr>
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })

		-- Lists all the community builtin extensions
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })

		-- List Diagnostics
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

		-- Resume last search
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

		-- Search recently open files
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Search for metal commands
		vim.keymap.set("n", "<leader>sm", function()
			require("telescope").extensions.metals.commands()
		end, { desc = "[S]earch [m] in metal commands" })

		-- Shortcut for searching your neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}

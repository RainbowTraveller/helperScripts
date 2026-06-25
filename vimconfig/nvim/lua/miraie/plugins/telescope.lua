return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-telescope/telescope-dap.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},

	config = function()
		require("telescope").setup({
			extensions = {
				["fzf"] = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		-- Safely enable installed telescope extensions
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("dap")

		-- UNCOMMENT THESE ONLY IF METALS AND NOICE ARE INSTALLED ELSEWHERE:
		-- require("telescope").load_extension("metals")
		-- require("telescope").load_extension("noice")

		local builtin = require("telescope.builtin")

		-- Project / Git file discovery
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sg", function()
			local is_git_repo = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1] == "true"
			if is_git_repo then
				builtin.git_files()
			else
				vim.notify("⚠ Not a git repository", vim.log.levels.WARN)
			end
		end, { desc = "[S]earch [G]it Files" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

		-- Grep and word searches
		vim.keymap.set("n", "<leader>sw", function()
			builtin.grep_string()
		end, { desc = "[S]earch current [W]ord" })

		vim.keymap.set("n", "<leader>sl", function()
			builtin.live_grep({ prompt_title = "Find string in open buffers...", grep_open_files = true })
		end, { desc = "[S]earch by [G]rep" })

		-- Telescope internal tracking mappings
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })

		-- Advanced context-aware fuzzy searching
		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Nvim global config lookup shortcut
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		-- Metals integration mapping (Uncomment if you use metals plugin)
		-- vim.keymap.set("n", "<leader>sm", function()
		-- 	require("telescope").extensions.metals.commands()
		-- end, { desc = "[S]earch [m] in metal commands" })
	end,
}

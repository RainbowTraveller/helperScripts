return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		local conf = require("telescope.config").values
		harpoon.setup(config)

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Add to Harpoon List" })
		-- This will show only plain files in the harpoon and not preview
		-- vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

		vim.keymap.set("n", "<C-f>", function()
			harpoon:list():select(1)
		end, { desc = "Select First" })
		vim.keymap.set("n", "<C-j>", function()
			harpoon:list():select(2)
		end, { desc = "Select Second" })
		vim.keymap.set("n", "<C-k>", function()
			harpoon:list():select(3)
		end, { desc = "Select Third" })
		vim.keymap.set("n", "<C-l>", function()
			harpoon:list():select(4)
		end, { desc = "Select Forth" })

		-- Toggle previous & next buffers stored within Harpoon list
		-- Closer to mac key mappings
		vim.keymap.set("n", "{", function()
			harpoon:list():prev()
		end, { desc = "Toggle to prev" })
		vim.keymap.set("n", "}", function()
			harpoon:list():next()
		end, { desc = "Toggle to next" })

		-- Telescope functionality to show list of the harpoon files
		-- along with the preview
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		local function clear_harpoon(harpoon_files)
			for i, item in ipairs(harpoon_files.items) do
				harpoon_files.items[i] = nil
			end
		end

		-- Displays files added in the harpoon
		vim.keymap.set("n", "<C-h>", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })

		-- Clear files added in the harpoon
		vim.keymap.set("n", "<leader>ch", function()
			clear_harpoon(harpoon:list())
		end, { desc = "Clear harpoon window" })
	end,
}

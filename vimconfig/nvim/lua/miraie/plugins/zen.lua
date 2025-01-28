return {
	"folke/zen-mode.nvim",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		-- zen-mode toggle
		vim.keymap.set("n", "<leader>zn", function()
			require("zen-mode").toggle({
				window = {
					width = 1, -- width will be 85% of the editor width
				},
			})
		end)
	end,
}

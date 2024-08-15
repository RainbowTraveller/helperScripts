return {
	-- Useful plugin to show you pending keybinds.
	--"folke/which-key.nvim",
	--event = "VeryLazy", -- Sets the loading event to 'VimEnter'
	--config = function() -- This is the function that runs, AFTER loading
	--	require("which-key").setup()

	--	-- Document existing key chains
	--	require("which-key").register({
	--		["<leader><leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
	--		["<leader><leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
	--		["<leader><leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
	--		["<leader><leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
	--		["<leader><leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
	--	})
	--end,
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		triggers = {
			{ "<leader>", mode = { "n", "v" } },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}

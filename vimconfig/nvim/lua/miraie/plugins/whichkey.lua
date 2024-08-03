return {
	-- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").register({
			["<leader><leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
			["<leader><leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
			["<leader><leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
			["<leader><leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
			["<leader><leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
		})
	end,
}

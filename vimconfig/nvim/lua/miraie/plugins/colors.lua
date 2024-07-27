return {
	{
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is

		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("tokyonight-night")

			-- You can configure highlights by doing something like
			vim.cmd.hi("Comment gui=none")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		event = "VeryLazy",
	},
	{
		"lunarvim/darkplus.nvim",
		event = "VeryLazy",
	},
	{
		"catppuccin/nvim",
		event = "VeryLazy",
		name = "catppuccin",
		-- priority = 1000,
		-- config = function()
		-- 	vim.cmd.colorscheme "catppuccin"
		-- end
	},
	{
		"EdenEast/nightfox.nvim",
		-- priority = 1000,
		event = "VeryLazy",
		-- config = function()
		-- 	vim.cmd.colorscheme "nightfox"
		-- end
	},
	{
		"rose-pine/neovim",
		event = "VeryLazy",
		-- config = function()
		-- 	vim.cmd.colorscheme "rose-pine-moon"
		-- end
	},
	{
		"LunarVim/lunar.nvim",
		-- event = "VeryLazy",
		--config = function()
		--	vim.cmd.colorscheme("lunar")
		--end,
	},
	{
		"lunarvim/Onedarker.nvim",
		event = "VeryLazy",
	},
	{
		"navarasu/onedark.nvim",
		event = "VeryLazy",
	},
	{
		"rebelot/kanagawa.nvim",
		event = "VeryLazy",
	},
	{
		"folke/tokyonight.nvim",
		event = "VeryLazy",
	},
	{
		"Everblush/nvim",
		event = "VeryLazy",
	},
	{
		"sainnhe/edge",
		event = "VeryLazy",
	},
	{
		"Mofiqul/vscode.nvim",
		event = "VeryLazy",
	},
	{
		"JoosepAlviste/palenightfall.nvim",
		event = "VeryLazy",
	},
	{
		"artanikin/vim-synthwave84",
		event = "VeryLazy",
	},
	{
		"loctvl842/monokai-pro.nvim",
		event = "VeryLazy",
	},
}

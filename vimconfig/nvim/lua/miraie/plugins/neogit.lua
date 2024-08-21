return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		local neogit = require("neogit")
		vim.keymap.set("n", "<leader>go", neogit.open, { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>pl", ":Neogit pull<CR>", { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>ps", ":Neogit push<CR>", { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>gb", ":Telescope git_brances<CR>", { silent = true, noremap = true })
		neogit.setup()
	end,
}

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
		neogit.setup({})
		vim.keymap.set("n", "<leader>go", neogit.open({ kind = "vsplit", silent = true, noremap = true }))
		vim.keymap.set("n", "<leader>gc", neogit.commit({ silent = true, noremap = true }))
		vim.keymap.set("n", "<leader>pl", neogit.pull({ silent = true, noremap = true }))
		vim.keymap.set("n", "<leader>ps", neogit.push()({ silent = true, noremap = true }))
		vim.keymap.set("n", "<leader>gr", neogit.rebase()({ silent = true, noremap = true }))
		vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { silent = true, noremap = true })
	end,
}

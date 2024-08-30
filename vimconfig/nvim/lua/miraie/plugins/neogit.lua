return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
	},
	config = function()
		require("neogit").setup({})
		local neogit = require("neogit")
		vim.keymap.set("n", "<leader>go", function()
			neogit.open({ kind = "vsplit" })
		end)
		vim.keymap.set("n", "<leader>gc", function()
			neogit.commit()
		end)
		vim.keymap.set("n", "<leader>gpl", function()
			neogit.pull()
		end)
		vim.keymap.set("n", "<leader>gps", function()
			neogit.push()
		end)
		vim.keymap.set("n", "<leader>gr", function()
			neogit.rebase()
		end)
		vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { silent = true, noremap = true })
	end,
}

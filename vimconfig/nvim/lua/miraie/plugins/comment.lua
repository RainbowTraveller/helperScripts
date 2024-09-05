return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()

			-- Key Remapping
			local api = require("Comment.api")
			local config = require("Comment.config")
			-- Toggle current line (linewise) using lc : Line Comment
			vim.keymap.set("n", "lc", api.toggle.linewise.current)

			-- Toggle current line (blockwise) using bc : Block Comment
			vim.keymap.set("n", "bc", api.toggle.blockwise.current)

			-- Toggle lines (linewise) with dot-repeat support
			-- Example: <leader>gc3j will comment 4 lines
			vim.keymap.set("n", "<leader>lc", api.call("toggle.linewise", "g@"), { expr = true })

			-- Toggle lines (blockwise) with dot-repeat support
			-- Example: <leader>gb3j will comment 4 lines
			vim.keymap.set("n", "<leader>bc", api.call("toggle.blockwise", "g@"), { expr = true })

			-- Insert line above with comment
			vim.keymap.set("n", "lcO", api.insert.linewise.above)

			-- Insert line below with comment
			vim.keymap.set("n", "lco", api.insert.linewise.below)

			-- Insert comment at the end of the line
			vim.keymap.set("n", "lcA", api.insert.linewise.eol)

			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

			-- Toggle selection (linewise): Toggle Linewise
			vim.keymap.set("x", "<leader>tl", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				api.toggle.linewise(vim.fn.visualmode())
			end)

			-- Toggle selection (blockwise): Toggle Blockwise
			vim.keymap.set("x", "<leader>tb", function()
				vim.api.nvim_feedkeys(esc, "nx", false)
				api.toggle.blockwise(vim.fn.visualmode())
			end)
		end,
	},
}

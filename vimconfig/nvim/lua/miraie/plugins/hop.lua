return {
	"phaazon/hop.nvim",
	branch = "v2", -- optional but strongly recommended
	config = function()
		-- you can configure Hop the way you like here; see :h hop-config
		require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		local hop = require("hop")
		local directions = require("hop.hint").HintDirection

		vim.keymap.set("", "<leader>c", function()
			hop.hint_char1({})
		end, { remap = true })

		vim.keymap.set("", "<leader>l", function()
			hop.hint_lines_skip_whitespace({})
		end, { remap = true })

		vim.keymap.set("", "<leader>v", function()
			hop.hint_vertical({})
		end, { remap = true })

		vim.keymap.set("", "<leader>a", function()
			hop.hint_anywhere({})
		end, { remap = true })
	end,
}

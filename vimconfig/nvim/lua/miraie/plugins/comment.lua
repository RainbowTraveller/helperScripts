return {
	{
		"numToStr/Comment.nvim",
		opts = {

			-- LHS of toggle mappings in NORMAL mode
			toggler = {
				--Line-comment toggle keymap
				line = "lcc",
				--Block-comment toggle keymap
				block = "lbc",
			},
			--LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				--Line-comment keymap
				line = "lc",
				--Block-comment keymap
				block = "lb",
			},
			--LHS of extra mappings
			extra = {
				--Add comment on the line above
				above = "lcO",
				--Add comment on the line below
				below = "lco",
				--Add comment at the end of line
				eol = "lcA",
			},
		},
	},
}

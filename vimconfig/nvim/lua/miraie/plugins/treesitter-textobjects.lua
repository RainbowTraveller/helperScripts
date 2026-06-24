return {

	"nvim-treesitter/nvim-treesitter-textobjects",
	lazy = true,
	opts = {

		textobjects = {
			select = {
				enable = true,
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				keymaps = {

					-- Assignment
					["a="] = { query = "@assignment.outer", desc = "Select outer part of assignment" },
					["i="] = { query = "@assignment.inner", desc = "Select inner part of assignment" },
					["l="] = { query = "@assignment.lhs", desc = "Select left side of part of assignment" },
					["r="] = { query = "@assignment.rhs", desc = "Select right side of part of assignment" },

					-- Parameter
					["ap"] = { query = "@parameter.outer", desc = "Select outer part of parameter/argument" },
					["ip"] = { query = "@parameter.inner", desc = "Select inner part of parameter/argument" },

					-- Conditional
					["ac"] = { query = "@condition.outer", desc = "Select outer part of condition" },
					["ic"] = { query = "@condition.inner", desc = "Select inner part of condition" },

					-- loop
					["al"] = { query = "@loop.outer", desc = "Select outer part of loop" },
					["il"] = { query = "@loop.inner", desc = "Select inner part of loop" },

					-- call to a function
					["af"] = { query = "@call.outer", desc = "Select outer part of call to a function" },
					["if"] = { query = "@call.inner", desc = "Select inner part of call to a function" },

					-- call to a function
					["am"] = { query = "@function.outer", desc = "Select outer part of function" },
					["im"] = { query = "@function.inner", desc = "Select inner part of function" },

					-- clas
					["as"] = { query = "@class.outer", desc = "Select outer part of class" },
					["is"] = { query = "@class.inner", desc = "Select inner part of class" },
				},

				swap = {
					enable = true,
					swap_next = {
						["<leader>np"] = "@parameter.inner",
						["<leader>nm"] = "@function.outer",
					},
					swap_previous = {
						["<leader>pp"] = "@parameter.inner",
						["<leader>pm"] = "@function.outer",
					},
				},

				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = { query = "@call.outer", desc = "Next function call start" },
						["]m"] = { query = "@function.outer", desc = "Next function start" },
						["]s"] = { query = "@class.outer", desc = "Next class start" },
						["]c"] = { query = "@condition.outer", desc = "Next condition start" },
						["]l"] = { query = "@loop.outer", desc = "Next loop start" },

						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						["]k"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]F"] = { query = "@call.outer", desc = "Next function call end" },
						["]M"] = { query = "@function.outer", desc = "Next function end" },
						["]S"] = { query = "@class.outer", desc = "Next class end" },
						["]C"] = { query = "@condition.outer", desc = "Next condition end" },
						["]L"] = { query = "@loop.outer", desc = "Next loop end" },
					},
					goto_previous_start = {
						["[f"] = { query = "@call.outer", desc = "Prev function call start" },
						["[m"] = { query = "@function.outer", desc = "Prev function start" },
						["[s"] = { query = "@class.outer", desc = "Prev class start" },
						["[c"] = { query = "@condition.outer", desc = "Prev condition start" },
						["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
					},
					goto_previous_end = {
						["[F"] = { query = "@call.outer", desc = "Prev function call end" },
						["[M"] = { query = "@function.outer", desc = "Prev function end" },
						["[S"] = { query = "@class.outer", desc = "Prev class end" },
						["[C"] = { query = "@condition.outer", desc = "Prev condition end" },
						["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
					},
				},
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- Repeat movement with ; and ,
		-- ensure ; goes forward and , goes backward regardless of the last direction
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

		-- vim way: ; goes to the direction you were moving.
		-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end,
}

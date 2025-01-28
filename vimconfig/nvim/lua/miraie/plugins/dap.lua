return {
	"mfussenegger/nvim-dap",
	optional = true,
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				vim.list_extend(opts.ensure_installed, { "java-test", "java-debug-adapter" })
			end,
		},
	},
	config = function()
		local dap = require("dap")
		-- Example mappings for usage with nvim-dap. If you don't use that, you can
		-- skip these
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end)

		vim.keymap.set("n", "<leader>dr", function()
			dap.repl.toggle()
		end)

		vim.keymap.set("n", "<leader>dK", function()
			require("dap.ui.widgets").hover()
		end)

		vim.keymap.set("n", "<leader>dt", function()
			dap.toggle_breakpoint()
		end)

		vim.keymap.set("n", "<leader>dso", function()
			dap.step_over()
		end)

		vim.keymap.set("n", "<leader>dsi", function()
			dap.step_into()
		end)

		vim.keymap.set("n", "<leader>dl", function()
			dap.run_last()
		end)
	end,
}

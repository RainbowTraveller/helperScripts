return {
	"stevearc/conform.nvim",
	config = function()
		local opts = {

			format_on_save = {
				timeout_ms = 1500, -- Increasing timout for scalafmt to get sufficient time and not timeout
				lsp_fallback = true,
				lsp_format = "fallback",
			},

			format_after_save = {
				lsp_format = "fallback",
			},

			-- Conform will notify you when a formatter errors
			-- notify_on_error = true,
			-- Conform will notify you when no formatters are available for the buffer
			-- notify_no_formatters = true,

			formatters_by_ft = {
				-- Use the "*" filetype to run formatters on all filetypes.
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = function(bufnr)
					if require("conform").get_formatter_info("ruff_format", bufnr).available then
						return { "ruff_format" }
					else
						return { "isort", "black" }
					end
				end,
				go = { "goimports", "gofmt" },
				java = { "google-java-format" },
				scala = { "scalafmt" },
				-- csharp = { "csharpier" },
				["*"] = { "codespell" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
				["_"] = { "trim_whitespace" },
			},
		}
		require("conform").setup(opts)
	end,
}

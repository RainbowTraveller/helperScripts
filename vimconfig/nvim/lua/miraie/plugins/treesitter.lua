return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"c",
			"cpp",
			"bash",
			"java",
			"json",
			"scala",
			"lua",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
			"go",
			"python",
			"tmux",
			"yaml",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"latex",
			"rust",
		},
		-- Autoinstall languages that are not installed
		auto_install = true,
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,
		-- List of parsers to ignore installing (or "all")
		ignore_install = { "javascript", "c_sharp" },
		highlight = {
			enable = true,
			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
			-- Highlight the @foo.bar capture group with the "Identifier" highlight group
			-- vim.api.nvim_set_hl(0, "@string", { link = "Identifier" }),
			disable = function(lang, buf)
				-- Check if the buffer exists
				if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
					return true
				end

				local max_filesize = 1024 * 1024 -- 1 MB
				-- Get file size
				local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
				-- Get the size in megabytes
				local fsize_mb = fsize / (1024 * 1024)

				-- You can define a file size threshold here
				local max_file_size_mb = 1.0 -- 1 megabyte threshold
				if fsize_mb > max_file_size_mb then
					-- Log a message for clarity (optional)
					vim.notify(
						"Treesitter highlighting disabled for large file: " .. vim.api.nvim_buf_get_name(bufnr),
						vim.log.levels.INFO
					)
					return true
				end
				-- vim.loop.fs_stat(): This function, part of the vim.loop (now vim.uv) API, is a more comprehensive tool.
				-- It's a binding to the underlying libuv library, which provides a non-blocking I/O API.
				-- fs_stat retrieves a full set of file statistics, not just the size. This includes a multitude of attributes like creation time, modification time,
				-- file type, and more. While powerful, retrieving all these statistics can be slightly less efficient than a function designed to get only one piece of
				-- information.
				--
				-- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				-- if ok and stats and stats.size > max_filesize then
				-- 	return true
				-- end
				return false
			end,
		},
		indent = { enable = true },

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
				scope_incremental = "<c-s>",
				node_decremental = "<c-backspace>",
			},
		},
	},
	config = function(_, opts)
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		---@diagnostic disable-next-line: missing-fields
		-- require("nvim-treesitter.configs").setup(opts)
		require("nvim-treesitter").setup(opts)

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}

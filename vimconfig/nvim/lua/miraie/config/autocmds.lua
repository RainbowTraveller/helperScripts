-- Common functions
local function augroup(name)
	return vim.api.nvim_create_augroup("miraie_" .. name, { clear = true })
end

-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
local map = function(keys, func, desc, buff)
	vim.keymap.set("n", keys, func, { buffer = buff, desc = "LSP: " .. desc })
end

---------------------------------- AUTOCOMMANDS --------------------------------------------------
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
--  `:help nvim_create_autocmd`
--  `:help nvim_create_augroup`
--  `:help event`
--  The function handles the event TextYankPost with call back
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	-- 		group = vim.api.nvim_create_augroup("miraie-highlight-yank", { clear = true }),
	group = augroup("hilight-yank"),
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 500,
			on_macro = true,
		})
	end,
})

-- format on save, the function is present in autoformat.lua file
-- The current buffer is passed as argument
-- The autoformat plugin has logic to decide which file it is and call
-- corresponding formatter
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp-attach"),
	callback = function(event)
		-- NOTE: Remember that lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself
		-- many times.
		--
		local buff = event.buf
		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition", buff)

		-- Find references for the word under your cursor.
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences", buff)

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation", buff)

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition", buff)

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols", buff)

		-- Fuzzy find all the symbols in your current workspace
		--  Similar to document symbols, except searches over your whole project.
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols", buff)

		-- Rename the variable under your cursor
		--  Most Language Servers support renaming across files, etc.
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame", buff)

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", buff)

		-- Opens a popup that displays documentation about the word under your cursor
		-- Displays hover information about the symbol under the cursor in a floating window.
		-- Callin it twice will jump into the floating window
		--  See `:help K` for why this keymap
		map("K", vim.lsp.buf.hover, "Hover Documentation", buff)

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration", buff)

		-- List all symbols in the current buffer in a quickfix window
		-- map("gds", vim.lsp.buf.document_symbol) -- telescope version
		-- List all symbols in the current workspace in a quickfix window
		-- map("gws", vim.lsp.buf.workspace_symbol) -- telescope version

		-- Execute the codelens under the cursor
		map("<leader>cl", vim.lsp.codelens.run, "[C]ode [L]ens", buff)

		-- Displays signature information about the symbol under the cursor in a floating window
		map("<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp", buff)
		map("<leader>f", vim.lsp.buf.format, "[F]ormat")
		map("<leader>hs", function()
			require("metals").hover_worksheet()
		end, "Hover [W]ork [S]heet", buff)
		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*.txt",
	callback = function()
		if vim.o.filetype == "help" then
			vim.cmd.wincmd("T")
		end
	end,
})

-- Delete trailing whitespaces before writing buffer
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

return {}

local function augroup(name)
	return vim.api.nvim_create_augroup("miraie_" .. name, { clear = true })
end

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
return {}

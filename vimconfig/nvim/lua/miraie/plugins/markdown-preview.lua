return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && sh install.sh",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	config = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.keymap.set("n", "<leader>md", ":MarkdownPreviewToggle<CR>", {})
	end,
}

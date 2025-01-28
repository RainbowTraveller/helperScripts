return {
	"preservim/vim-pencil",
	config = function()
		vim.g["pencil#wrapModeDefault"] = "soft"
		vim.keymap.set("n", "<leader>pc", ":PencilToggle<CR>", {})
		vim.keymap.set("n", "<leader>ph", ":PencilHard<CR>", {})
		vim.keymap.set("n", "<leader>ps", ":PencilSoft<CR>", {})
	end,
}

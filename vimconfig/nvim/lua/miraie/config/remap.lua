local map = function()
	vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

	-- Visual mode selected block can be moved using J and K
	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

	-- while appending the line below to the current one, the cursor remains
	-- at the beginning
	vim.keymap.set("n", "J", "mzJ`z")
	-- Jump to the middle and then end : half page jumping
	vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Down
	vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Up

	-- While searching a term, it keeps the cursor
	-- always in the middle
	vim.keymap.set("n", "n", "nzzzv`") -- forward
	vim.keymap.set("n", "N", "Nzzzv`") -- backwards

	-- visual mode select and copy and again select and paste
	-- the original word remains in the yanked register
	vim.keymap.set("x", "<leader>p", '"_dP')

	-- use this to yank into the system clipboard and not vim register
	vim.keymap.set("n", "<leader>y", '"+y')
	vim.keymap.set("v", "<leader>y", '"+y')
	vim.keymap.set("n", "<leader>Y", '"+Y')

	-- TODO: Need some investigation (Ctrl + a L)
	vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizeri<CR>")

	--  TODO: Quickfix functionality of the vim
	vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
	vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
	vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
	vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

	-- Enables %s expression with the word under the cursor
	vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
	-- Make the file executable in the normal mode
	vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
	-- Diagnostic keymaps
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
end

map()

return {}

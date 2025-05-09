local map = function()
	-- Help yourself  WARNING : This will disable arrow keys
	vim.keymap.set("n", "<RIGHT>", ":cnext<CR>")
	vim.keymap.set("n", "<RIGHT><RIGHT>", ":cnfile<CR><C-G")
	vim.keymap.set("n", "<LEFT>", ":cprev<CR>")
	vim.keymap.set("n", "<LEFT><LEFT>", ":cpfile<CR><C-G")

	-- Go to pwd
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
	-- Can be used for the clipboard paste as well
	-- x indicates both visual and select mode
	vim.keymap.set("x", "<leader>p", '"_dP')

	-- CLIPBOARD PASTE
	vim.keymap.set("n", "<leader>p", '"+p')

	-- CLIPBOARD YANK
	-- use this to yank into the system clipboard and not vim register
	-- followed by motiuon keys e.g <leader>y + w will yank word and put it in the clipboard
	vim.keymap.set("n", "<leader>y", '"+y')
	-- Yank entire line into the clipboard
	vim.keymap.set("n", "<leader>yy", '"+yy')
	-- vim.keymap.set("n", "<leader>Y", '"+Y') Yank entire line, but previous one is more convenient
	vim.keymap.set("v", "<leader>y", '"+y')

	-- TODO: Need some investigation (Ctrl + a L)
	vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizeri<CR>")

	--  TODO: Quickfix functionality of the vim
	vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
	vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
	vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
	vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

	-- Enables %s expression with the word under the cursor
	vim.keymap.set("n", "<leader>z", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
	-- Make the file executable in the normal mode
	vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

	-- Diagnostic keymaps

	-- all workspace diagnostics
	vim.keymap.set("n", "<leader>aa", vim.diagnostic.setqflist)

	-- all workspace errors
	vim.keymap.set("n", "<leader>ae", function()
		local opts = { severity = "E" }
		vim.diagnostic.setqflist(opts)
	end)

	-- all workspace warnings
	vim.keymap.set("n", "<leader>aw", function()
		local opts = { severity = "W" }
		vim.diagnostic.setqflist(opts)
	end)

	-- buffer diagnostics only
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	-- Dismiss Noice message
	vim.keymap.set("n", "<leader>dm", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
end

map()

return {}

local options = function()
	vim.opt.guicursor = ""

	-- Relative numbering and line numbering is must
	vim.opt.nu = true
	vim.opt.relativenumber = true

	-- Set tab and spaces
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.expandtab = true

	-- Please help indenting
	vim.opt.smartindent = true
	vim.opt.autoindent = true

	-- Let backspace delete indent
	vim.opt.backspace = indent, eol, start

	-- No text wrap
	vim.opt.wrap = false

	-- Back up settings
	vim.opt.swapfile = false
	vim.opt.backup = false
	-- stores the undo tree on the disk under this folder
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
	vim.opt.undofile = true

	-- search high light
	vim.opt.hlsearch = true -- highlight search word
	vim.opt.showmatch = true -- Show matching brackets/parenthesis
	vim.opt.incsearch = true -- Find as you type search
	vim.opt.ignorecase = true -- Case insensitive search
	vim.opt.smartcase = true -- Case sensitive when uc present
	vim.opt.redrawtime = 0

	vim.opt.termguicolors = true
	vim.opt.colorcolumn = "80" -- vertical column displayed in column 80

	-- Miscellaneous
	vim.opt.scrolloff = 8
	vim.opt.signcolumn = "yes"
	vim.opt.isfname:append("@-@")
	vim.opt.updatetime = 50
	vim.opt.mousehide = true -- Hide the mouse cursor while typing
	vim.opt.showmode = true -- Display the current mode
	vim.opt.linespace = 0 -- No extra spaces between rows
	vim.opt.wildmenu = true -- Show list instead of just completing
	vim.opt.scrolljump = 5 -- Lines to scroll when cursor leaves screen
	vim.opt.scrolloff = 3 -- Minimum lines to keep above and below cursor
	vim.opt.foldmethod = "syntax"
	vim.opt.foldlevel = 1
	vim.opt.foldclose = "all"
	vim.opt.list = false
	vim.opt.listchars:append({ extends = "#" }) -- Highlight problematic whitespace
	vim.opt.listchars:append({ tab = ">~" }) -- Highlight problematic whitespace
	vim.opt.listchars:append({ trail = "•" }) -- Highlight problematic whitespace
	vim.opt.wildignore:append({ "*.o,*.bak,*.class,*.pyc" })
	vim.opt.laststatus = 2
	vim.opt.virtualedit = "onemore" -- Allow for cursor beyond last character
	vim.opt.history = 1000 -- Store a ton of history (default is 20)
	vim.opt.spell = true -- Spell checking on
	vim.opt.hidden = true -- Allow buffer switching without saving

	-- Functions
	vim.keymap.set("n", "<leader><leader>", function()
		vim.cmd("so")
	end)
end
options()

return {}

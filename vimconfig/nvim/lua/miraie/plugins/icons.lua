return {
	"glepnir/nerdicons.nvim",
	cmd = "NerdIcons",
	opts = {
		border = "single", -- Border
		prompt = "󰨭 ", -- Prompt Icon
		preview_prompt = " ", -- Preview Prompt Icon
		width = 0.5, -- float window width
		down = "<C-n>", -- Move down in preview
		up = "<C-p>", -- Move up in preview
		copy = "<C-y>", -- Copy to the clipboard
	},
	config = function(opts)
		require("nerdicons").setup({ opts })
	end,
}

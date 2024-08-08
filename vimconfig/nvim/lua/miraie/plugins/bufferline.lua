return {

	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	-- lazy = false,
	config = function()
		local bufferline = require("bufferline")

		bufferline.setup({
			options = {
				mode = "buffers",
				style_preset = bufferline.style_preset.default,
				numbers = "both",
				modified_icon = "*",
				indicator = {
					icon = "▎",
					style = "icon",
				},
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
				separator_style = "think",
				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
				diagnostics = "nvim_lsp",
				color_icons = true,
				show_buffer_icons = true, -- disable filetype icons for buffers
				show_buffer_close_icons = true,
				show_close_icon = true,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					-- return "("..count..")"
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
			},
		})
	end,
}

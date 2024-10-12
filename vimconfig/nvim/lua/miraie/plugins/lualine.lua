local function get_lsp_name()
	local msg = "LS Inactive"
	local buf_clients = vim.lsp.get_clients()
	if next(buf_clients) == nil then
		if type(msg) == "boolean" or #msg == 0 then
			return "LS Inactive"
		end
	end
	local buf_client_names = {}

	for _, client in pairs(buf_clients) do
		table.insert(buf_client_names, client.name)
	end

	local unique_client_names = vim.fn.uniq(buf_client_names)

	local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"
	return language_servers
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	config = function()
		require("lualine").setup({
			options = {
				-- theme = "dracula",
				-- theme = "horizon",
				-- theme = "moonfly",
				icon_enabled = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype", get_lsp_name },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}

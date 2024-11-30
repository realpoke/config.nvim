return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "right",
				width = 80,
			},
		})
		vim.keymap.set("n", "<Leader><C-e>", ":Neotree toggle<CR>")
	end,
}

return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.pairs").setup({})
		require("mini.tabline").setup({})
		require("mini.statusline").setup({
			use_icons = vim.g.have_nerd_font,
		})
		require("mini.notify").setup({})
		require("mini.cursorword").setup({})
		require("mini.indentscope").setup({})
	end,
}

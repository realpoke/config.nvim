return {
	"Bleksak/laravel-ide-helper.nvim",
	config = function()
		require("laravel-ide-helper").setup({})
	end,

	enabled = function()
		return vim.fn.filereadable("artisan") ~= 0
	end,

	keys = {
		{
			"<leader>lhm",
			function()
				require("laravel-ide-helper").generate_models()
			end,
			desc = "[L]aravel [H]elper: Generate [M]odel Info For All Model",
		},
	},
}

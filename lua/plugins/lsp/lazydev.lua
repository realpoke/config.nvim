return {
	"folke/lazydev.nvim",
	ft = "lua",
	config = function()
		require("lazydev").setup({
			libarary = {
				{
					path = "luvit-meta/libarary",
					words = {
						"vim%.uv",
					},
				},
			},
		})
	end,
}

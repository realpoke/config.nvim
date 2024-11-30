return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.executable("make") == 1 then
					return "make install_jsregexp"
				end
			end)(),
		},
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		{
			"roobert/tailwindcss-colorizer-cmp.nvim",
			config = true,
		},
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local tailwindcss_colorizer_cmp = require("tailwindcss-colorizer-cmp")

		luasnip.config.setup({})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },

			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<C-n>"] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Scroll the documentation window [b]ack / [f]orward
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-y>"] = cmp.mapping.confirm({ select = true }),

				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don't need this, because nvim-cmp will display
				--  completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete({}),

				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
			}),
			sources = {
				{
					name = "lazydev",
					group_index = 0,
				},
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "supermaven" },
				{ name = "tailwindcss_colorizer_cmp" },
			},

			formatting = {
				format = function(entry, vim_item)
					-- Apply the lspkind formatting first
					vim_item = lspkind.cmp_format({
						mode = "symbol",
						preset = "default",
						maxwidth = {
							menu = 50,
							abbr = 50,
						},
						ellipsis_char = "...",
						show_labelDetails = false,
						symbol_map = {
							Supermaven = "",
						},
					})(entry, vim_item)

					-- Apply the tailwindcss-colorizer-cmp formatting
					vim_item = tailwindcss_colorizer_cmp.formatter(entry, vim_item)

					return vim_item
				end,
			},
		})
	end,
}

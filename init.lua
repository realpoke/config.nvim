vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.breakindent = true
vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.colorcolumn = "80,120"

vim.opt.signcolumn = "yes"

vim.opt.showmode = false

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true

vim.opt.scrolloff = 8

vim.opt.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory [-]" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<C-w>q", ":%bd|e#|bd#<CR>", { desc = "Close all buffers and re-open current one [<C-w>q]" })
vim.keymap.set("n", "<C-q>", ":bd<CR>", { desc = "Close current buffer and switch to the next one [<C-q>]" })
vim.keymap.set("n", "<C-l>", ":bn<CR>", { desc = "Go to the next buffer [<C-l>]" })
vim.keymap.set("n", "<C-h>", ":bp<CR>", { desc = "Go to the previous buffer [<C-h>]" })

vim.keymap.set("n", "<leader>tn", function()
	require("neotest").run.run()
end, { desc = "[T]est [N]earest" })
vim.keymap.set("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "[T]est [F]ile" })
vim.keymap.set("n", "<leader>ts", function()
	require("neotest").run.run({ suite = true })
end, { desc = "[T]est [S]uite" })
vim.keymap.set("n", "<leader>to", function()
	require("neotest").output.open()
end, { desc = "[T]oggle test [O]utput" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		"tpope/vim-sleuth",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
		{
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			branch = "0.1.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
					cond = function()
						return vim.fn.executable("make") == 1
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },
			},
			config = function()
				require("telescope").setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
				})

				pcall(require("telescope").load_extension, "fzf")
				pcall(require("telescope").load_extension, "ui-select")

				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>sa", builtin.find_files, { desc = "[S]earch [A]ll" })
				vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
				vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
				vim.keymap.set("n", "<leader>sf", builtin.git_files, { desc = "[S]earch [F]iles (Git-Tracked Only)" })
				vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
				vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
				vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
				vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
				vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
				vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files[.]" })
				vim.keymap.set("n", "<leader>s<leader>", builtin.buffers, { desc = "[S]earch existing buffers[ ]" })

				vim.keymap.set("n", "<leader>sn", function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end, { desc = "[S]earch [N]eovim files" })
			end,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "williamboman/mason.nvim", config = true },
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",

				{ "j-hui/fidget.nvim", opts = {} },
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
					callback = function(event)
						local map = function(keys, func, desc, mode)
							mode = mode or "n"
							vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
						map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
						map(
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols"
						)
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					end,
				})

				local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
				local diagnostic_signs = {}
				for type, icon in pairs(signs) do
					diagnostic_signs[vim.diagnostic.severity[type]] = icon
				end
				vim.diagnostic.config({ signs = { text = diagnostic_signs } })

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities =
					vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

				local servers = {
					lua_ls = {
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					},
				}

				require("mason").setup()

				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua",
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls" },
					automatic_installation = false,
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},
		{
			"stevearc/oil.nvim",
			config = function()
				require("oil").setup()
			end,
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
		},
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					php = { "pint" },
				},
			},
		},
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				{
					"L3MON4D3/LuaSnip",
					build = (function()
						if vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
				},
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				local lspkind = require("lspkind")
				luasnip.config.setup({})

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = { completeopt = "menu,menuone,noinsert" },
					mapping = cmp.mapping.preset.insert({
						["<C-n>"] = cmp.mapping.select_next_item(),
						["<C-p>"] = cmp.mapping.select_prev_item(),

						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),

						["<C-y>"] = cmp.mapping.confirm({ select = true }),

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
						["<C-e>"] = cmp.mapping.abort(),
					}),
					sources = {
						{
							name = "lazydev",
							group_index = 0,
						},
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
					},
					formatting = {
						format = function(entry, vim_item)
							vim_item = lspkind.cmp_format({
								mode = "symbol",
								preset = "default",
								maxwidth = {
									menu = 50,
									abbr = 50,
								},
								ellipsis_char = "...",
								show_labelDetails = false,
							})(entry, vim_item)

							return vim_item
						end,
						fields = { "abbr", "menu", "kind" },
						expandable_indicator = true,
					},
				})
			end,
		},
		{
			"onsails/lspkind.nvim",
		},
		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-neotest/nvim-nio",
				"nvim-lua/plenary.nvim",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-treesitter/nvim-treesitter",
				"V13Axel/neotest-pest",
			},
			config = function()
				---@diagnostic disable-next-line: missing-fields
				require("neotest").setup({
					adapters = {
						require("neotest-pest"),
					},
				})
			end,
		},
		{
			"kdheepak/lazygit.nvim",
			lazy = true,
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			keys = {
				{
					"<leader>git",
					"<cmd>LazyGit<cr>",
					desc = "Open Lazy[GIT]",
				},
			},
		},
		{
			"echasnovski/mini.cursorword",
			config = function()
				require("mini.cursorword").setup()
			end,
			version = false,
		},
		{
			"echasnovski/mini.indentscope",
			config = function()
				require("mini.indentscope").setup({
					mappings = {
						object_scope = "",
						object_scope_with_border = "",

						goto_top = "",
						goto_bottom = "",
					},
				})
			end,
			version = false,
		},
		{
			"echasnovski/mini.statusline",
			config = function()
				local statusline = require("mini.statusline")
				statusline.setup()

				---@diagnostic disable-next-line: duplicate-set-field
				statusline.section_location = function()
					return "%2l:%-2v"
				end
			end,
			version = false,
		},
		{
			"echasnovski/mini.tabline",
			config = function()
				require("mini.tabline").setup()
			end,
			version = false,
		},
		{
			"rose-pine/neovim",
			name = "rose-pine",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("colorscheme rose-pine")
			end,
		},
		{
			"echasnovski/mini.hipatterns",
			config = function()
				local hipatterns = require("mini.hipatterns")
				hipatterns.setup({
					highlighters = {
						fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
						hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
						todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
						note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

						hex_color = hipatterns.gen_highlighter.hex_color(),
					},
				})
			end,
			version = false,
		},
		{
			"echasnovski/mini.icons",
			config = function()
				require("mini.icons").setup()
			end,
			version = false,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs",
			config = function()
				---@class ParserConfig
				local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

				local blade_parser_config = {
					install_info = {
						url = "https://github.com/EmranMR/tree-sitter-blade",
						files = { "src/parser.c" },
						branch = "main",
					},
					filetype = "blade",
				}

				parser_config.blade = blade_parser_config

				vim.filetype.add({
					pattern = {
						[".*%.blade%.php"] = "blade",
					},
				})

				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"lua",
						"luadoc",
						"vim",
						"vimdoc",
						"html",
						"php_only",
						"php",
						"blade",
						"markdown",
						"markdown_inline",
					},
					auto_install = true,
					highlight = {
						enable = true,
					},
					indent = {
						enable = true,
					},
					modules = { "all" },
					sync_install = false,
					ignore_install = {},
				})
			end,
		},
	},
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
	install = {
		colorscheme = { "rose-pine" },
	},
})

-- vim: ts=2 sts=2 sw=2 et

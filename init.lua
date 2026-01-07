vim.opt.number = true

vim.opt.undofile = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.winborder = "rounded"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.colorcolumn = "80,120"

vim.opt.cursorline = true

vim.opt.signcolumn = "yes:1"

vim.opt.scrolloff = 8

vim.opt.confirm = true

vim.opt.showmode = false

vim.g.mapleader = " "

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

local hooks = {}
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local action = hooks[ev.data.spec.name]
		if action and ev.data.kind ~= "delete" then
			vim.schedule(function()
				action(ev.data)
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true }),
	once = true,
	callback = function()
		local fuzzy_implementation = "prefer_rust_with_warning"
		if 0 ~= vim.system({ "rustc", "+nightly", "--version" }):wait().code then
			vim.notify(
				"blink.cmp: could not find ruest fuzzy finder, falling back to lua. Make sure 'rustup' is installed."
			)
			fuzzy_implementation = "lua"
		end
		require("blink.cmp").setup({
			sources = {
				default = { "supermaven", "lsp", "path", "snippets", "buffer" },
				providers = {
					supermaven = {
						name = "supermaven",
						module = "blink-cmp-supermaven",
						async = true,
					},
				},
			},
			fuzzy = { implementation = fuzzy_implementation },
		})
	end,
})

vim.keymap.set("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<C-w>q", ":%bd|e#|bd#<CR>", { desc = "Close all buffers and re-open current one [<C-w>q]" })
vim.keymap.set("n", "<C-q>", ":bd<CR>", { desc = "Close current buffer and switch to the next one [<C-q>]" })
vim.keymap.set("n", "<C-l>", ":bn<CR>", { desc = "Go to the next buffer [<C-l>]" })
vim.keymap.set("n", "<C-h>", ":bp<CR>", { desc = "Go to the previous buffer [<C-h>]" })

vim.pack.add({ "https://github.com/rose-pine/neovim" })
vim.cmd("colorscheme rose-pine")

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
require("mini.cursorword").setup()
require("mini.icons").setup()
require("mini.tabline").setup()
require("mini.statusline").setup()
require("mini.notify").setup()
require("mini.snippets").setup()
require("mini.pick").setup()
require("mini.extra").setup()
require("mini.trailspace").setup()
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
	},
	hex_color = hipatterns.gen_highlighter.hex_color(),
})
vim.keymap.set("n", "<leader>sr", ":Pick resume<CR>", { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sf", ":Pick files<CR>", { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sl", ":Pick grep_live<CR>", { desc = "[S]earch by Grep [L]ive" })
vim.keymap.set("n", "<leader>sg", ":Pick git_files<CR>", { desc = "[S]earch [G]it files" })
vim.keymap.set("n", "<leader>sh", ":Pick help<CR>", { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sd", ":Pick diagnostic<CR>", { desc = "[S]earch [D]iagnostic" })
vim.keymap.set("n", "<leader>sk", ":Pick keymaps<CR>", { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sn", function()
	require("mini.pick").builtin.files({}, { source = { cwd = vim.fn.stdpath("config") } })
end, { desc = "[S]earch [N]eovim config" })

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
	skip_confirm_for_simple_edits = true,
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory [-]" })

vim.pack.add({ "https://github.com/kdheepak/lazygit.nvim" })
vim.keymap.set("n", "<leader>git", ":LazyGit<CR>", { desc = "Lazy[GIT]" })

hooks["nvim-treesitter"] = function()
	vim.notify("Treesitter: Updating...")
	vim.cmd("TSUpdate")
	vim.notify("Treesitter: Updated...")
end
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
require("nvim-treesitter").setup({
	ensure_installed = { "json", "lua", "vim", "php", "blade" },
	auto_install = true,
	highlight = {
		enable = true,
	},
})
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
})
require("mason").setup()
require("mason-lspconfig").setup()

vim.pack.add({ "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" })
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"intelephense",
		"laravel_ls",
		"stylua",
		"tailwindcss",
		"blade-formatter",
		"pint",
		"prettierd",
	},
	auto_update = true,
})

vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		php = { "pint" },
		blade = { "blade-formatter" },
		javascript = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.pack.add({ "https://github.com/folke/lazydev.nvim" })
require("lazydev").setup()

hooks["blink.cmp"] = function(ev)
	local res = vim.system({ "cargo", "build", "--release" }, {
		cwd = ev.path .. "/lua/blink/cmp/fuzzy/rust",
	}):wait()
	if res.code == 0 then
		vim.notify("blink.cmp: Build complete...")
	else
		vim.notify("blink.cmp: Build failed...\n" .. (res.stderr or ""), vim.log.levels.ERROR)
	end
end
vim.pack.add({
	"https://github.com/Saghen/blink.cmp",
	"https://github.com/Huijiro/blink-cmp-supermaven",
})

package.loaded["cmp"] = {
	register_source = function() end,
}
vim.pack.add({ "https://github.com/supermaven-inc/supermaven-nvim" })
require("supermaven-nvim").setup({
	log_level = "off",
	disable_inline_completion = true,
	disable_keymaps = true,
})

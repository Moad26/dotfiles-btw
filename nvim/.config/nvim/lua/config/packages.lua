vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			vim.cmd.packadd("nvim-treesitter")
			require("nvim-treesitter").update():wait(300000)
		end
	end,
})

vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/Kaiser-Yang/blink-cmp-dictionary",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-lint",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/ts-comments.nvim",
	"https://github.com/benomahony/uv.nvim",
})

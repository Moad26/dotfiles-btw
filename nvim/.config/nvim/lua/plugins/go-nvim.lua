return {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = function()
		require("go").setup(opts)
		return {
			-- lsp_keymaps = false,
			-- other options
			lsp_cfg = false,
			lsp_on_attach = false,
			lsp_inlay_hints = { enable = false },
		}
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()',
}

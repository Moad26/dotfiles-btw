return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local colorscheme_file = vim.fn.stdpath("data") .. "/last_colorscheme.txt"

			local function save_colorscheme(scheme)
				local file = io.open(colorscheme_file, "w")
				if file then
					file:write(scheme)
					file:close()
				end
			end

			local function load_last_colorscheme()
				local file = io.open(colorscheme_file, "r")
				if file then
					local scheme = file:read("*all")
					file:close()
					return scheme
				end
				return "tokyonight-night"
			end

			vim.defer_fn(function()
				local last_colorscheme = load_last_colorscheme()
				local ok, _ = pcall(vim.cmd.colorscheme, last_colorscheme)
				if not ok then
					vim.cmd.colorscheme("tokyonight-night")
				end
			end, 0)

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					save_colorscheme(vim.g.colors_name)
				end,
			})
		end,
	},
	{ "dgox16/oldworld.nvim", lazy = true },
	{ "topazape/oldtale.nvim", lazy = true },
	{ "yorumicolors/yorumi.nvim", lazy = true },
	{ "slugbyte/lackluster.nvim", lazy = true },
	{ "scottmckendry/cyberdream.nvim", lazy = true },
	{ "ramojus/mellifluous.nvim", lazy = true },
	{
		"0xstepit/flow.nvim",
		lazy = true,
		opts = {
			theme = {
				style = "dark", --  "dark" | "light"
				contrast = "default", -- "default" | "high"
				transparent = false, -- true | false
			},
		},
	},
	{
		"morhetz/gruvbox",
		lazy = true,
	},
	{
		"bluz71/vim-nightfly-guicolors",
		lazy = true,
		config = function()
			vim.g.nightflyItalics = true
			vim.g.nightflyCursorColor = true
			vim.g.nightflyNormalFloat = true
			vim.g.nightflyWinSeparator = 2
		end,
	},
	{
		"sainnhe/everforest",
		lazy = true,
		config = function()
			vim.g.everforest_enable_italic = true
			vim.g.everforest_background = "soft"
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = true,
		--[[config = function()
			vim.g.gruvbox_material_background = "hard"
		end,]]
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
	},
	{
		"Shatur/neovim-ayu",
		lazy = true,
	},
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
	},
	{
		"shaunsingh/nord.nvim",
		lazy = true,
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},
	{
		"savq/melange-nvim",
		lazy = true,
	},
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = true,
	},
	{
		"ribru17/bamboo.nvim",
		lazy = true,
		config = function()
			require("bamboo").setup({})
		end,
	},
	{
		"olivercederborg/poimandres.nvim",
		lazy = true,
	},
	{
		"xero/miasma.nvim",
		lazy = true,
	},
	{
		"comfysage/evergarden",
		lazy = true,
		opts = {
			variant = "hard",
			overrides = {},
		},
	},
	{
		"AlexvZyl/nordic.nvim",
		lazy = true,
	},
	{
		"vague2k/vague.nvim",
		lazy = true,
	},
	{
		"zenbones-theme/zenbones.nvim",
		lazy = true,
		dependencies = { "rktjmp/lush.nvim" },
	},
	{
		"thesimonho/kanagawa-paper.nvim",
		lazy = true,
	},
	{
		"webhooked/kanso.nvim",
		lazy = true,
	},
	{
		"zootedb0t/citruszest.nvim",
		lazy = true,
	},
	{
		"datsfilipe/vesper.nvim",
		lazy = true,
	},
	{
		"sontungexpt/witch",
		lazy = true,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = true,
		config = function()
			vim.opt.background = "dark"
		end,
	},
	{
		"kvrohit/rasmus.nvim",
		lazy = true,
	},
	{
		"eldritch-theme/eldritch.nvim",
		lazy = true,
	},
	{
		"sam4llis/nvim-tundra",
		lazy = true,
	},
	{
		"olimorris/onedarkpro.nvim",
		lazy = true,
	},
	{
		"tiagovla/tokyodark.nvim",
		lazy = true,
	},
	{
		"mellow-theme/mellow.nvim",
		lazy = true,
	},
}

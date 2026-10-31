vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/dgox16/oldworld.nvim",
	"https://github.com/topazape/oldtale.nvim",
	"https://github.com/yorumicolors/yorumi.nvim",
	"https://github.com/slugbyte/lackluster.nvim",
	"https://github.com/scottmckendry/cyberdream.nvim",
	"https://github.com/ramojus/mellifluous.nvim",
	"https://github.com/0xstepit/flow.nvim",
	"https://github.com/morhetz/gruvbox",
	"https://github.com/bluz71/vim-nightfly-guicolors",
	"https://github.com/sainnhe/everforest",
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/sainnhe/gruvbox-material",
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/EdenEast/nightfox.nvim",
	"https://github.com/Shatur/neovim-ayu",
	"https://github.com/craftzdog/solarized-osaka.nvim",
	"https://github.com/shaunsingh/nord.nvim",
	"https://github.com/Mofiqul/dracula.nvim",
	"https://github.com/savq/melange-nvim",
	{ src = "https://github.com/bluz71/vim-moonfly-colors", name = "moonfly" },
	"https://github.com/ribru17/bamboo.nvim",
	"https://github.com/olivercederborg/poimandres.nvim",
	"https://github.com/xero/miasma.nvim",
	"https://github.com/comfysage/evergarden",
	"https://github.com/AlexvZyl/nordic.nvim",
	"https://github.com/vague2k/vague.nvim",
	"https://github.com/rktjmp/lush.nvim",
	"https://github.com/zenbones-theme/zenbones.nvim",
	"https://github.com/thesimonho/kanagawa-paper.nvim",
	"https://github.com/webhooked/kanso.nvim",
	"https://github.com/zootedb0t/citruszest.nvim",
	"https://github.com/datsfilipe/vesper.nvim",
	"https://github.com/sontungexpt/witch",
	"https://github.com/nyoom-engineering/oxocarbon.nvim",
	"https://github.com/kvrohit/rasmus.nvim",
	"https://github.com/eldritch-theme/eldritch.nvim",
	"https://github.com/sam4llis/nvim-tundra",
	"https://github.com/olimorris/onedarkpro.nvim",
	"https://github.com/tiagovla/tokyodark.nvim",
	"https://github.com/mellow-theme/mellow.nvim",
	{ src = "https://github.com/Everblush/nvim", name = "everblush" },
	"https://github.com/owickstrom/vim-colors-paramount",
	"https://github.com/no-clown-fiesta/no-clown-fiesta.nvim",
	"https://github.com/casedami/neomodern.nvim",
	"https://github.com/kyazdani42/blue-moon",
	"https://github.com/Aejkatappaja/cendre",
	"https://github.com/roobert/palette.nvim",
	"https://github.com/kdheepak/monochrome.nvim",
})

vim.g.nightflyItalics = true
vim.g.nightflyCursorColor = true
vim.g.nightflyNormalFloat = true
vim.g.nightflyWinSeparator = 2
vim.g.everforest_enable_italic = true
vim.g.everforest_background = "soft"
vim.opt.background = "dark"

require("flow").setup({ theme = { style = "dark", contrast = "default", transparent = false } })
require("bamboo").setup({})
require("evergarden").setup({ variant = "hard", overrides = {} })

local colorscheme_file = vim.fn.stdpath("data") .. "/last_colorscheme.txt"
local file = io.open(colorscheme_file, "r")
local scheme = file and file:read("*all") or "tokyonight-night"
if file then
	file:close()
end
if not pcall(vim.cmd.colorscheme, scheme) then
	vim.cmd.colorscheme("tokyonight-night")
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(ev)
		local output = io.open(colorscheme_file, "w")
		if output then
			output:write(ev.match)
			output:close()
		end
	end,
})

vim.g.mapleader = " "

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- UI
vim.opt.showtabline = 0
vim.opt.cmdheight = 0
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.list = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"

-- Scroll
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Timing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Files
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true
vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	command = "checktime",
})

-- Grep
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Folding (native treesitter folds)
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Neovim 0.12: global border options
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"

require("vim._core.ui2").enable({})

-- Neovim 0.12 highlight groups — persist across colorscheme changes
local function apply_0_12_highlights()
	vim.api.nvim_set_hl(0, "PmenuBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "PmenuShadow", { bg = "#000000", blend = 40 })
	vim.api.nvim_set_hl(0, "PmenuShadowThrough", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "SnippetTabstopActive", { underline = true, bold = true })
end

apply_0_12_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = apply_0_12_highlights,
})

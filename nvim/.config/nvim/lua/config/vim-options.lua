vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Number of spaces per tab
vim.opt.softtabstop = 2 -- Editing feels like 2 spaces per tab
vim.opt.showtabline = 0
vim.opt.cmdheight = 0 -- Hide the cmdline bar; ui2 floats it as a popup when triggered

vim.opt.shiftwidth = 2 -- Indent by 2 spaces
vim.opt.smartindent = true -- Smart indentation
vim.opt.autoindent = true
vim.opt.wrap = false -- Disable line wrapping
vim.opt.cursorline = true -- Highlight the current line
vim.g.mapleader = " "
vim.g.background = "dark"
vim.opt.termguicolors = true

vim.opt.swapfile = false

vim.opt.splitright = true -- Split vertical windows to the right
vim.opt.splitbelow = true -- Split horizontal windows below
vim.opt.scrolloff = 8 -- Minimum lines to keep above/below cursor
vim.opt.sidescrolloff = 8 -- Minimum columns to keep left/right of cursor
vim.opt.updatetime = 250 -- Faster completion (default 4000ms)
vim.opt.timeoutlen = 300 -- Time to wait for mapped sequence (for which-key)

vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.list = true -- Show whitespace characters

vim.opt.incsearch = true -- Show search matches while typing
vim.opt.hlsearch = true -- Highlight search results
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.smartcase = true -- But make search case-sensitive if uppercase letters are used

vim.opt.clipboard = "unnamedplus" -- Use system clipboard by default
vim.opt.autoread = true
vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	command = "checktime",
})
vim.opt.undofile = true
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.splitkeep = "screen"
vim.opt.smoothscroll = true

-- Neovim 0.12: new global border options for floating windows and completion popup.
-- Setting these means you don't need border = "rounded" in individual plugin configs.
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"

require("vim._core.ui2").enable({})

-- Neovim 0.12: new highlight groups — set after every colorscheme change so they survive theme switches.
local function apply_0_12_highlights()
	-- Completion popup border matches float borders
	vim.api.nvim_set_hl(0, "PmenuBorder", { link = "FloatBorder" })
	-- Soft shadow beneath floating windows
	vim.api.nvim_set_hl(0, "PmenuShadow", { bg = "#000000", blend = 40 })
	vim.api.nvim_set_hl(0, "PmenuShadowThrough", { bg = "NONE" })
	-- Visible active snippet tabstop (used by LuaSnip)
	vim.api.nvim_set_hl(0, "SnippetTabstopActive", { underline = true, bold = true })
end

apply_0_12_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = apply_0_12_highlights,
})

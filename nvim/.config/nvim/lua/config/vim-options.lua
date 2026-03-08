vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Number of spaces per tab
vim.opt.softtabstop = 2 -- Editing feels like 2 spaces per tab
vim.opt.showtabline = 2
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

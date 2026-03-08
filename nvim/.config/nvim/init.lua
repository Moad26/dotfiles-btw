local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.vim-options")
require("config.keymap")
require("lazy").setup("plugins")

local has_luasnip, luasnip_loader = pcall(require, "luasnip.loaders.from_lua")
if has_luasnip then
	luasnip_loader.load({ paths = "~/.config/nvim/LuaSnip/" })
	luasnip_loader.lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
end

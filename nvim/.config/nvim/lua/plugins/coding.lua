require("lazydev").setup({})
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	fuzzy = { implementation = "lua" }, -- No downloaded native binary on NixOS.
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		per_filetype = { markdown = { "buffer", "path", "dictionary" } },
		providers = {
			lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
			dictionary = {
				name = "dictionary",
				module = "blink-cmp-dictionary",
				min_keyword_length = 2,
				opts = {
					-- Directory discovery only reads .txt; our dictionaries use .dict.
					dictionary_files = vim.fn.glob(vim.fn.stdpath("config") .. "/dictionary/*.dict", false, true),
				},
			},
		},
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },
		documentation = { auto_show = true },
	},
	signature = { enabled = true },
})

require("nvim-ts-autotag").setup({})
require("ts-comments").setup({})
-- Keep automatic .venv activation; package management and test runs stay in the shell.
require("uv").setup({ keymaps = false, picker_integration = false, notify_activate_venv = false })

local treesitter = require("nvim-treesitter")
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
		if not lang or not vim.tbl_contains(treesitter.get_available(), lang) then
			return
		end
		treesitter.install({ lang }):await(function(err)
			vim.schedule(function()
				if err then
					vim.notify(tostring(err), vim.log.levels.ERROR)
				elseif
					vim.api.nvim_buf_is_valid(ev.buf)
					and vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype) == lang
				then
					vim.treesitter.start(ev.buf, lang)
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end)
		end)
	end,
})

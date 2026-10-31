local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		vue = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		less = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		handlebars = { "prettier" },
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		cuda = { "clang-format" },
		lua = { "stylua" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		go = { "goimports", "gofumpt", "golines" },
		toml = { "taplo" },
		typst = { "typstyle" },
		proto = { "buf" },
		nix = { "nixfmt" },
	},
	format_on_save = { lsp_format = "fallback", timeout_ms = 3000 },
	formatters = {
		golines = { prepend_args = { "--max-len=120" } },
		prettier = { prepend_args = { "--tab-width", "2", "--print-width", "100" } },
		["clang-format"] = { prepend_args = { "--style=Google" } },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>gf", function()
	conform.format({ lsp_format = "fallback", async = false, timeout_ms = 1000 })
end, { desc = "Format file or range (in visual mode)" })

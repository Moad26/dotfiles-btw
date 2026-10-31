local lint = require("lint")
-- golangci-lint v2 changed its output flags.
lint.linters.golangcilint.args = {
	"run",
	"--output.json.path",
	"stdout",
	"--issues-exit-code",
	"0",
	"--show-stats=false",
	function()
		return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
	end,
}
-- Parse available output even when analysis exits with a timeout/error.
lint.linters.golangcilint.ignore_exitcode = true
lint.linters.cpplint.args = { "--filter=-legal/copyright", "--linelength=120" }
lint.linters_by_ft = {
	go = { "golangcilint" },
	python = { "ruff" },
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	c = { "cpplint" },
	cpp = { "cpplint" },
	cuda = { "cpplint" },
	json = { "jsonlint" },
	bash = { "shellcheck" },
	sh = { "shellcheck" },
	markdown = { "markdownlint" },
	proto = { "buf_lint" },
	dockerfile = { "hadolint" },
	nix = { "statix", "deadnix" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("lint", { clear = true }),
	callback = function()
		lint.try_lint()
	end,
})
vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
end, { desc = "Lint current file" })

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- golangci-lint v2.x changed CLI flags; override nvim-lint's built-in args
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
		-- exit code 3 = timeout/analysis error; treat as non-fatal so nvim-lint
		-- still parses whatever output was produced rather than discarding it
		lint.linters.golangcilint.ignore_exitcode = true

		lint.linters.cpplint.args = {
			"--filter=-legal/copyright",
			"--linelength=120", -- Optional: adjust line length if needed
		}

		lint.linters_by_ft = {
			-- Go
			go = { "golangcilint" },
			-- Python
			python = {
				"ruff",
			},

			-- JavaScript/TypeScript
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },

			-- C/C++ (optional, clangd provides most diagnostics)
			c = { "cpplint" },
			cpp = { "cpplint" },
			cuda = { "cpplint" },

			-- JSON
			json = { "jsonlint" },

			-- Bash
			bash = { "shellcheck" },
			sh = { "shellcheck" },

			-- Markdown
			markdown = { "markdownlint" },
			proto = { "buf_lint" },

			-- Docker
			dockerfile = { "hadolint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}

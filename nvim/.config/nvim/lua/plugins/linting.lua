return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

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
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		local function file_in_cwd(file_name)
			return vim.fs.find(file_name, {
				upward = true,
				stop = vim.loop.cwd():match("(.+)/"),
				path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
				type = "file",
			})[1]
		end

		local function remove_linter(linters, linter_name)
			for k, v in pairs(linters) do
				if v == linter_name then
					linters[k] = nil
					break
				end
			end
		end

		local function linter_in_linters(linters, linter_name)
			for k, v in pairs(linters) do
				if v == linter_name then
					return true
				end
			end
			return false
		end

		local function remove_linter_if_missing_config_file(linters, linter_name, config_file_name)
			if linter_in_linters(linters, linter_name) and not file_in_cwd(config_file_name) then
				remove_linter(linters, linter_name)
			end
		end

		local function try_linting()
			local linters = lint.linters_by_ft[vim.bo.filetype]

			-- if linters then
			--   -- remove_linter_if_missing_config_file(linters, "eslint_d", ".eslintrc.cjs")
			--   remove_linter_if_missing_config_file(linters, "eslint_d", "eslint.config.js")
			-- end

			lint.try_lint(linters)
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				try_linting()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			try_linting()
		end, { desc = "Trigger linting for current file" })
	end,
}

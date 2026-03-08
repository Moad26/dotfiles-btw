return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- Web development
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

				-- Python - Using Ruff for both formatting and import sorting
				python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },

				-- C/C++
				c = { "clang-format" },
				cpp = { "clang-format" },
				cuda = { "clang-format" },

				-- Lua
				lua = { "stylua" },

				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },
				-- Go (Updated with golines)
				go = { "goimports", "gofumpt", "golines" },
				-- Other
				toml = { "taplo" },
				typst = { "typstyle" },
			},

			-- Format on save configuration
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 3000,
			},

			-- Format after save for slower formatters (optional)
			-- format_after_save = {
			--   lsp_fallback = true,
			-- },

			-- Formatter-specific options
			formatters = {
				golines = {
					prepend_args = { "--max-len=120" },
				},
				-- Customize prettier
				prettier = {
					-- You can add custom options here if needed
					prepend_args = { "--tab-width", "2", "--print-width", "100" },
				},
				-- Customize clang-format
				["clang-format"] = {
					prepend_args = { "--style=Google" }, -- or "LLVM", "Mozilla", etc.
				},
			},
		})

		-- Keymap for manual formatting
		vim.keymap.set({ "n", "v" }, "<leader>gf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}

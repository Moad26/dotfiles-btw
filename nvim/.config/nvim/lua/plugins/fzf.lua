return {
	"ibhagwan/fzf-lua",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			keymap = {
				builtin = {
					["<Tab>"] = "down",
					["<S-Tab>"] = "up",
				},
				fzf = {
					["tab"] = "down",
					["shift-tab"] = "up",
				},
			},
		})

		fzf.register_ui_select()

		local keymap = vim.keymap.set

		keymap("n", "<C-p>", fzf.files, { desc = "Find Files" })
		keymap("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
		keymap("n", "<leader><leader>", fzf.oldfiles, { desc = "Recent Files" })

		-- LSP pickers
		keymap("n", "gr", fzf.lsp_references, { desc = "Lsp references" })
		keymap("n", "gd", fzf.lsp_definitions, { desc = "Lsp definitions" })
		keymap("n", "gi", fzf.lsp_implementations, { desc = "Lsp implementations" })
		keymap("n", "gt", fzf.lsp_typedefs, { desc = "Lsp type definitions" })

		keymap("n", "<leader>ds", fzf.lsp_document_symbols, { desc = "Document Symbols" })
		keymap("n", "<leader>dd", fzf.diagnostics_document, { desc = "Document diagnostics" })
		keymap("n", "<leader>dx", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
		keymap("n", "<leader>dq", fzf.quickfix, { desc = "Quickfix" })

		-- Additional useful pickers
		keymap("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
		keymap("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
		keymap("n", "<leader>fc", fzf.commands, { desc = "Commands" })
		keymap("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
		keymap("n", "<leader>fw", fzf.grep_cword, { desc = "Word Under Cursor" })
		keymap("n", "<leader>fr", fzf.resume, { desc = "Resume Last Picker" })

		-- Git pickers
		keymap("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
		keymap("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
		keymap("n", "<leader>gb", fzf.git_branches, { desc = "Git Branches" })
		keymap("n", "<leader>tc", function()
			fzf.colorschemes({
				ignore_patterns = {
					-- native vim/nvim builtins
					"^blue$",
					"^darkblue$",
					"^default$",
					"^delek$",
					"^desert$",
					"^elflord$",
					"^evening$",
					"^habamax$",
					"^industry$",
					"^koehler$",
					"^lunaperche$",
					"^morning$",
					"^murphy$",
					"^pablo$",
					"^peachpuff$",
					"^quiet$",
					"^retrobox$",
					"^ron$",
					"^shine$",
					"^slate$",
					"^sorbet$",
					"^torte$",
					"^wildcharm$",
					"^zaibatsu$",
					"^zellner$",
				},
				sort_lastused = true, -- your last used floats to top, rest alphabetical
			})
		end, { desc = "Switch Colorscheme" })
	end,
}

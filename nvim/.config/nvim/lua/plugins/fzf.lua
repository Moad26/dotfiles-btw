local fzf = require("fzf-lua")
fzf.setup({
	keymap = {
		builtin = { ["<Tab>"] = "down", ["<S-Tab>"] = "up" },
		fzf = { ["tab"] = "down", ["shift-tab"] = "up" },
	},
	diagnostics = {
		actions = {
			["ctrl-y"] = function(selected)
				if selected and #selected > 0 then
					vim.fn.setreg("+", selected[1])
					vim.notify("Copied to clipboard", vim.log.levels.INFO)
				end
			end,
		},
	},
})
fzf.register_ui_select()

local map = vim.keymap.set
map("n", "<C-p>", fzf.files, { desc = "Find files" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
map("n", "<leader><leader>", fzf.oldfiles, { desc = "Recent files" })
map("n", "gr", fzf.lsp_references, { desc = "LSP references" })
map("n", "gd", fzf.lsp_definitions, { desc = "LSP definitions" })
map("n", "gi", fzf.lsp_implementations, { desc = "LSP implementations" })
map("n", "gt", fzf.lsp_typedefs, { desc = "LSP type definitions" })
map("n", "<leader>ds", fzf.lsp_document_symbols, { desc = "Document symbols" })
map("n", "<leader>dd", fzf.diagnostics_document, { desc = "Document diagnostics" })
map("n", "<leader>dx", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
map("n", "<leader>dq", fzf.quickfix, { desc = "Quickfix" })
map("n", "<leader>dc", fzf.lsp_code_actions, { desc = "Code actions" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
map("n", "<leader>fc", fzf.commands, { desc = "Commands" })
map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>fw", fzf.grep_cword, { desc = "Word under cursor" })
map("n", "<leader>fy", fzf.registers, { desc = "Registers" })
map("n", "<leader>fr", fzf.resume, { desc = "Resume last picker" })
map("n", "<leader>tc", function()
	fzf.colorschemes({
		ignore_patterns = {
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
		sort_lastused = true,
	})
end, { desc = "Switch colorscheme" })

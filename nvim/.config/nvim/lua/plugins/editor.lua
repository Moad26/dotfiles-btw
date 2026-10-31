require("oil").setup({ view_options = { show_hidden = true } })
require("gitsigns").setup({})

local map = vim.keymap.set
local gitsigns = require("gitsigns")
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>ut", function()
	vim.cmd.packadd("nvim.undotree")
	vim.cmd.Undotree()
end, { desc = "Toggle native undo tree" })
map("n", "<leader>lg", function()
	vim.cmd.tabnew()
	vim.cmd.terminal("lazygit")
	vim.api.nvim_create_autocmd("TermClose", {
		buffer = vim.api.nvim_get_current_buf(),
		once = true,
		callback = function(ev)
			if vim.v.event.status == 0 then
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(ev.buf) then
						vim.api.nvim_buf_delete(ev.buf, { force = true })
					end
				end)
			end
		end,
	})
	vim.cmd.startinsert()
end, { desc = "LazyGit" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
map("n", "<leader>gt", gitsigns.toggle_current_line_blame, { desc = "Toggle Git blame" })
map("n", "]c", function()
	gitsigns.nav_hunk("next")
end, { desc = "Next Git hunk" })
map("n", "[c", function()
	gitsigns.nav_hunk("prev")
end, { desc = "Previous Git hunk" })
map("n", "<leader>gS", gitsigns.stage_hunk, { desc = "Stage Git hunk" })
map("n", "<leader>gR", gitsigns.reset_hunk, { desc = "Reset Git hunk" })

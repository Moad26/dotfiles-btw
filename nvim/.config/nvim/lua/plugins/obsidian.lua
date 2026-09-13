local function open_vault_pdf()
	local vault_path = vim.fn.expand("~/Desktop/obsidian/")
	local fzf = require("fzf-lua")
	fzf.files({
		cmd = 'find "' .. vault_path .. '" -type f -name "*.pdf"',
		cwd = vault_path,
		previewer = false,
		actions = {
			["default"] = function(selected)
				if selected and #selected > 0 then
					-- fzf-lua prepends icon+path; strip to raw path
					local path = require("fzf-lua").path.entry_to_file(selected[1]).path
					vim.fn.jobstart({ "zathura", path }, { detach = true })
				end
			end,
		},
	})
end

return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
		"saghen/blink.cmp",
	},
	opts = {
		workspaces = {
			{
				name = "obsidian",
				path = "~/Desktop/obsidian",
			},
		},

		notes_subdir = "02-Notes",

		daily_notes = {
			folder = "02-Notes",
			date_format = "%Y-%m-%d",
		},

		templates = {
			folder = "05-Template",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		attachments = {
			img_folder = "03-attachement",
		},

		completion = {
			nvim_cmp = false,
			min_chars = 2,
		},

		picker = {
			name = "fzf-lua",
		},

		preferred_link_style = "wiki",
		open_notes_in = "current",

		-- follow_url_func = function(url)
		-- 	vim.fn.jobstart({ "zathura", url })
		-- end,

		ui = {
			enable = true,
		},
	},

	keys = {
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
		{ "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open note" },
		{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
		{ "<leader>op", open_vault_pdf, desc = "Open vault PDF" },
		{ "<leader>od", "<cmd>ObsidianDailies<cr>", desc = "Daily notes" },
		{ "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Tags" },
		{ "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links in file" },
		{ "gf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
	},
}

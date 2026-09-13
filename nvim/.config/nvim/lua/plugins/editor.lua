return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		lazy = false,
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
	},

	{
		"mbbill/undotree",
		keys = {
			{ "<leader>ut", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
		},
	},

	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
		keys = {
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
			{ "<leader>gt", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Line Blame" },
			{ "]c", "<cmd>Gitsigns next_hunk<CR>", desc = "Next Hunk" },
			{ "[c", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev Hunk" },
			{ "<leader>gS", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
			{ "<leader>gR", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	},
}

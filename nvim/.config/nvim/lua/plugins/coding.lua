return {
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = {
			"nvim-mini/mini.nvim",
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
		},
		version = "v1.*",

		opts = {
			keymap = {
				preset = "default",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
				["<C-e>"] = { "hide" },
				["<CR>"] = { "accept", "fallback" },

				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<C-N>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
							{ "source_name" },
						},

						components = {
							kind_icon = {
								text = function(ctx)
									local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)

									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr ~= "" then
											icon = color_item.abbr
										end
									end

									return icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr_hl_group then
											return color_item.abbr_hl_group
										end
									end

									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
				ghost_text = {
					enabled = true,
				},
			},

			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},
		},

		opts_extend = { "sources.default" },
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			"ibhagwan/fzf-lua",
			{
				"folke/snacks.nvim",
				opts = {
					terminal = {},
				},
			},
		},
		event = "LspAttach",
		opts = {},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup({})
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
		opts = {
			focus = true,
		},
		cmd = "Trouble",
		keys = {
			{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
			{
				"<leader>xd",
				"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "Open trouble document diagnostics",
			},
			{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
			{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
			{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
		},
	},

	--Tmux

	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	--Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")

			local function enable_ts_features()
				vim.treesitter.start()
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end

			local ts_group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = ts_group,
				callback = function(ev)
					local ft = vim.bo[ev.buf].filetype
					if ft == "" then
						return
					end

					-- Query fresh each time so newly installed parsers are detected.
					local available = treesitter.get_available()
					if not vim.tbl_contains(available, ft) then
						return
					end

					local installed = treesitter.get_installed()
					if vim.tbl_contains(installed, ft) then
						enable_ts_features()
					else
						vim.notify(
							("nvim-treesitter: auto-installing parser for '%s'…"):format(ft),
							vim.log.levels.INFO
						)
						-- install() is async; chain onto its promise so features
						-- are enabled in the triggering buffer once done.
						treesitter.install(ft):map(function()
							if vim.api.nvim_buf_is_valid(ev.buf) and vim.bo[ev.buf].filetype == ft then
								vim.schedule(enable_ts_features)
							end
						end)
					end
				end,
			})
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	lazy = false,
	-- 	build = ":TSUpdate",
	-- 	config = function()
	-- 		local treesitter = require("nvim-treesitter")
	-- 		local available_parsers = treesitter.get_available()
	-- 		local installed_parsers = treesitter.get_installed()
	--
	-- 		local ts_group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
	--
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			group = ts_group,
	-- 			callback = function()
	-- 				local ft = vim.bo.filetype
	--
	-- 				if vim.tbl_contains(available_parsers, ft) then
	-- 					if not vim.tbl_contains(installed_parsers, ft) then
	-- 						vim.notify("Auto-installing parser for: " .. ft)
	-- 						treesitter.install(ft)
	-- 						table.insert(installed_parsers, ft)
	-- 					else
	-- 						vim.treesitter.start()
	-- 						vim.wo.foldmethod = "expr"
	-- 						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- 						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	-- 					end
	-- 				end
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
}

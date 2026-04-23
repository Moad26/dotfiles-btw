return {

	{
		"folke/snacks.nvim",
		dependencies = {
			"echasnovski/mini.icons",
		},
		lazy = false,
		priority = 1000,

		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },

			quickfile = { enabled = true },

			dashboard = {
				preset = {
					header = [[
ooooo      ooo oooooo     oooo ooooo ooo        ooooo
`888b.     `8'  `888.     .8'  `888' `88.       .888'
 8 `88b.    8    `888.   .8'    888   888b     d'888
 8   `88b.  8     `888. .8'     888   8 Y88. .P  888
 8     `88b.8      `888.8'      888   8  `888'   888
 8       `888       `888'       888   8    Y     888
o8o        `8        `8'       o888o o8o        o888o
        ]],
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},

			explorer = { enabled = true },

			indent = { enabled = true },

			input = { enabled = true },

			scope = { enabled = true },

			notifier = {
				enabled = true,
				timeout = 3000,
				style = "compact",
			},

			statuscolumn = { enabled = true },

			words = { enabled = true },

			zen = { enabled = true },

			terminal = {
				enabled = true,
				win = {
					border = "rounded",
					style = "terminal",
				},
			},

			lazygit = {
				enabled = true,
				win = {
					border = "rounded",
					style = "lazygit",
				},
			},
		},

		keys = {
			{
				"<leader>un",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>ud",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Toggle Zen Mode",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>lg",
				function()
					Snacks.lazygit()
				end,
				desc = "LazyGit",
			},
			{
				"<leader>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git Blame Line",
			},
			{
				"<leader>go",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Open in GitHub/GitLab",
			},
			{
				"<C-n>",
				function()
					Snacks.explorer()
				end,
				desc = "Explorer",
			},
			{
				"<leader>tt",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
		},

		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd
					vim.notify = Snacks.notifier.notify
				end,
			})
			vim.opt.inccommand = "split"
		end,
	},

	-- Statusline — doom emacs evil-line style
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			local has_icons, mini_icons = pcall(require, "mini.icons")

			local function get_hl_fg(group)
				local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
				if hl.fg then
					return string.format("#%06x", hl.fg)
				end
				return nil
			end

			local function setup_evil_line()
				local colors = {
					bg = get_hl_fg("Normal")
							and (function()
								local hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
								return hl.bg and string.format("#%06x", hl.bg) or "#202328"
							end)()
						or "#202328",
					fg = get_hl_fg("Normal") or "#bbc2cf",
					red = get_hl_fg("DiagnosticError") or "#ec5f67",
					green = get_hl_fg("String") or "#98be65",
					blue = get_hl_fg("Function") or "#51afef",
					cyan = get_hl_fg("Type") or "#008080",
					magenta = get_hl_fg("Keyword") or "#c678dd",
					orange = get_hl_fg("Special") or "#FF8800",
					violet = get_hl_fg("Statement") or "#a9a1e1",
					yellow = get_hl_fg("Number") or "#ECBE7B",
				}

				local mode_color = {
					n = colors.magenta,
					i = colors.green,
					v = colors.blue,
					["\22"] = colors.blue,
					V = colors.blue,
					c = colors.violet,
					no = colors.magenta,
					s = colors.orange,
					S = colors.orange,
					["\19"] = colors.orange,
					ic = colors.yellow,
					R = colors.cyan,
					Rv = colors.cyan,
					cv = colors.magenta,
					ce = colors.magenta,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.magenta,
					t = colors.magenta,
				}

				local mode_str = {
					n = "<(•ᴗ•)>",
					i = "<(•o•)>",
					v = "(>*-*)>",
					["\22"] = "(>*-*)>",
					V = "(>*-*)>",
					c = "(>*~*)>",
					no = "<(•ᴗ•)>",
					s = "(>*-*)>",
					S = "(>*-*)>",
					["\19"] = "(>*-*)>",
					ic = "<(•o•)>",
					R = "(v*-*)>",
					Rv = "(v*-*)>",
					cv = "<(•ᴗ•)>",
					ce = "<(•ᴗ•)>",
					r = "(v*-*)>",
					rm = "(v*-*)>",
					["r?"] = "(v*-*)>",
					["!"] = "<(•ᴗ•)>",
					t = "<(•ᴗ•)>",
				}

				-- Evil-line: all sections empty except c (left) and x (right)
				local config = {
					options = {
						globalstatus = true,
						component_separators = "",
						section_separators = "",
						theme = {
							normal = { c = { fg = colors.fg, bg = colors.bg } },
							inactive = { c = { fg = colors.fg, bg = colors.bg } },
						},
					},
					sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_y = {},
						lualine_z = {},
						lualine_c = {},
						lualine_x = {},
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = { "filename" },
						lualine_x = { "location" },
						lualine_y = {},
						lualine_z = {},
					},
				}

				local function ins_left(component)
					table.insert(config.sections.lualine_c, component)
				end
				local function ins_right(component)
					table.insert(config.sections.lualine_x, component)
				end

				-- ▊ mode-colored bar (left edge accent)
				ins_left({
					function()
						return "▊"
					end,
					color = function()
						return { fg = mode_color[vim.fn.mode()] or colors.magenta }
					end,
					padding = { left = 0, right = 1 },
				})

				-- Mode icon (cute face)
				ins_left({
					function()
						return mode_str[vim.fn.mode()] or "<(•ᴗ•)>"
					end,
					color = function()
						return { fg = mode_color[vim.fn.mode()] or colors.magenta, gui = "bold" }
					end,
					padding = { left = 1, right = 1 },
				})

				-- File size
				ins_left({
					function()
						local file = vim.fn.expand("%:p")
						if file == "" or file == nil then
							return ""
						end
						local size = vim.fn.getfsize(file)
						if size <= 0 then
							return ""
						end
						local suffixes = { "b", "k", "m", "g" }
						local i = 1
						while size > 1024 and i < #suffixes do
							size = size / 1024
							i = i + 1
						end
						return string.format("%.1f%s", size, suffixes[i])
					end,
					cond = function()
						return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
					end,
					color = { fg = colors.fg },
					padding = { left = 1, right = 1 },
				})

				-- Filetype icon (from mini.icons)
				ins_left({
					function()
						if not has_icons then
							return ""
						end
						local icon, _, _ = mini_icons.get("file", vim.api.nvim_buf_get_name(0))
						return icon or ""
					end,
					cond = function()
						return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
					end,
					color = function()
						if not has_icons then
							return { fg = colors.fg }
						end
						local _, hl, _ = mini_icons.get("file", vim.api.nvim_buf_get_name(0))
						return { fg = get_hl_fg(hl) }
					end,
					padding = { left = 1, right = 0 },
				})

				-- Filename
				ins_left({
					"filename",
					cond = function()
						return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
					end,
					color = { fg = colors.magenta, gui = "bold" },
					symbols = { modified = "●", readonly = "", unnamed = "[No Name]", newfile = "[New]" },
					padding = { left = 1, right = 1 },
				})

				-- Branch
				ins_left({
					"branch",
					icon = "",
					color = { fg = colors.fg },
					padding = { left = 1, right = 1 },
				})

				-- Diff
				ins_left({
					"diff",
					symbols = { added = " ", modified = " ", removed = " " },
					diff_color = {
						added = { fg = colors.green },
						modified = { fg = colors.orange },
						removed = { fg = colors.red },
					},
					cond = function()
						local gitdir = vim.fn.finddir(".git", vim.fn.expand("%:p:h") .. ";")
						return gitdir and #gitdir > 0
					end,
					padding = { left = 1, right = 1 },
				})

				-- Diagnostics
				ins_left({
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = { error = " ", warn = " ", info = " ", hint = " " },
					diagnostics_color = {
						error = { fg = colors.red },
						warn = { fg = colors.yellow },
						info = { fg = colors.cyan },
						hint = { fg = colors.green },
					},
					padding = { left = 1, right = 1 },
				})

				-- ═══ right side ═══

				-- Active LSP clients
				ins_right({
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if #clients == 0 then
							return "No Active Lsp"
						end
						local names = vim.tbl_map(function(c)
							return c.name
						end, clients)
						return "LSP: " .. table.concat(names, ", ")
					end,
					icon = "",
					color = { fg = colors.fg },
					padding = { left = 1, right = 1 },
				})

				-- Encoding
				ins_right({
					"o:encoding",
					color = { fg = colors.fg },
					padding = { left = 1, right = 1 },
				})

				-- File format
				ins_right({
					"fileformat",
					icons_enabled = false,
					color = { fg = colors.green },
					padding = { left = 1, right = 1 },
				})

				-- Location
				ins_right({
					"location",
					color = { fg = colors.fg },
					padding = { left = 1, right = 1 },
				})

				-- Progress
				ins_right({
					"progress",
					color = { fg = colors.fg },
					padding = { left = 1, right = 1 },
				})

				require("lualine").setup(config)
			end

			setup_evil_line()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.defer_fn(setup_evil_line, 50)
				end,
			})
		end,
	},
}

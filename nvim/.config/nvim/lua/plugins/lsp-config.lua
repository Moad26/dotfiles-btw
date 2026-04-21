return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"whoissethdaniel/mason-tool-installer.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/schemastore.nvim",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			-- this next line is added because lua_ls is not found by nvim while already existing in the mason/bin
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
			local keymap = vim.keymap
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"ruff",
					"clang-format",
					"eslint_d",
					"mypy",
					"cpplint",
					"jsonlint",
					"markdownlint",
					"shfmt",
					"shellcheck",
					"gofumpt",
					"goimports",
					"golines",
					"golangci-lint",
					"delve",
					"debugpy",
					"taplo",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("userlspconfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local function map(keys, func, desc)
						opts.desc = desc
						keymap.set("n", keys, func, opts)
					end

					map("[d", vim.diagnostic.goto_prev, "go to previous diagnostic")
					map("]d", vim.diagnostic.goto_next, "go to next diagnostic")
					-- K (hover), grn (rename), gra (code_action), grr (references) are now
					-- built-in default LSP keymaps in Neovim 0.12 — no need to define them here.
					map("<leader>rs", ":lsprestart<cr>", "restart lsp")
					-- map("<leader>ca", vim.lsp.buf.code_action, "see available code actions")
				end,
			})

			-- NOTE: sign_define() for diagnostics was removed in Neovim 0.12.
			-- Signs are now configured via the signs.text table inside vim.diagnostic.config().
			vim.diagnostic.config({
				virtual_text = { enabled = true, source = "always", prefix = "●" },
				underline = true,
				float = { border = "rounded", source = "always" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘ ",
						[vim.diagnostic.severity.WARN] = "▲ ",
						[vim.diagnostic.severity.HINT] = "⚑ ",
						[vim.diagnostic.severity.INFO] = "» ",
					},
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local on_attach = function(client, bufnr)
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
				if client.name == "ts_ls" or client.name == "volar" then
					client.server_capabilities.documentformattingprovider = false
				end
				if client.server_capabilities.inlayhintprovider then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end

			local servers = {
				gopls = {
					settings = {
						gopls = {
							codelenses = { generate = true },
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							staticcheck = true,
						},
					},
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=bundled",
						"--fallback-style=llvm",
					},
					init_options = { usePlaceholders = true },
				},
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "standard",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "openFilesOnly",
							},
						},
					},
				},

				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				cssls = {
					settings = {
						css = { validate = true, lint = { unknownAtRules = "ignore" } },
						scss = { validate = true, lint = { unknownAtRules = "ignore" } },
						less = { validate = true, lint = { unknownAtRules = "ignore" } },
					},
				},
				jsonls = {
					settings = {
						json = {
							validate = { enable = true },
							schemas = require("schemastore").json.schemas(),
						},
					},
				},
				lua_ls = {
					cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				bashls = {
					settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } },
				},
				tinymist = {
					settings = { formatterMode = "typstyle", exportPdf = "never", semanticTokens = "disable" },
				},
				html = { filetypes = { "html", "templ" } },
				graphql = { filetypes = { "graphql", "gql", "svelte", "astro", "vue" } },
				emmet_ls = {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
					},
				},
				svelte = {},
				tailwindcss = {},
				marksman = {},
				neocmake = {},
			}

			for name, config in pairs(servers) do

				config.capabilities = capabilities
				config.on_attach = on_attach

				vim.lsp.config(name, config)
			end

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_enable = true,
			})
		end,
	},
}

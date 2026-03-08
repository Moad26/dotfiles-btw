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
			local fzf = require("fzf-lua")
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

			vim.api.nvim_create_autocmd("lspattach", {
				group = vim.api.nvim_create_augroup("userlspconfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					local function map(keys, func, desc)
						opts.desc = desc
						keymap.set("n", keys, func, opts)
					end

					map("gr", fzf.lsp_references, "show lsp references")
					map("gd", fzf.lsp_definitions, "show lsp definitions")
					map("gi", fzf.lsp_implementations, "show lsp implementations")
					map("gt", fzf.lsp_typedefs, "show lsp type definitions")
					map("<leader>d", fzf.diagnostics_document, "show buffer diagnostics")
					map("[d", vim.diagnostic.goto_prev, "go to previous diagnostic")
					map("]d", vim.diagnostic.goto_next, "go to next diagnostic")
					map("K", vim.lsp.buf.hover, "show documentation")
					map("<leader>rs", ":lsprestart<cr>", "restart lsp")
					map("<leader>rn", vim.lsp.buf.rename, "smart rename")
					map("<leader>ca", vim.lsp.buf.code_action, "see available code actions")
				end,
			})

			vim.diagnostic.config({
				virtual_text = { enabled = true, source = "always", prefix = "●" },
				signs = true,
				underline = true,
				float = { border = "rounded", source = "always" },
			})

			local signs = { error = "✘ ", warn = "▲ ", hint = "⚑ ", info = "» " }
			for type, icon in pairs(signs) do
				local hl = "diagnosticsign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

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
								fieldalignment = true,
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
				--[[ pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
							reportReturnType = "warning",
							reportOptionalMemberAccess = "warning",
							reportOptionalOperand = "warning",
							reportOptionalSubscript = "warning",
							reportGeneralTypeIssues = "warning",
						},
					},
				},
			}, ]]
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
				if name == "tsserver" then
					name = "ts_ls"
				end

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
	-- Lazydev
	{
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
}

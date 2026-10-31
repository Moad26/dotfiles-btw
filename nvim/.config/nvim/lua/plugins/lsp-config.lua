vim.keymap.set("n", "<leader>rs", "<cmd>lsp restart<cr>", { desc = "Restart LSP" })
vim.diagnostic.config({
	virtual_text = { source = "always", prefix = "●" },
	underline = true,
	float = { border = "rounded", source = "always" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = "▲ ",
			[vim.diagnostic.severity.HINT] = "󰈽 ",
			[vim.diagnostic.severity.INFO] = "» ",
		},
	},
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
local on_attach = function(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	if client.name == "ts_ls" or client.name == "volar" then
		client.server_capabilities.documentFormattingProvider = false
	end
	if client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

local servers = {
	nil_ls = {},
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
				analyses = { useany = true },
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
			json = { validate = { enable = true }, schemas = require("schemastore").json.schemas() },
		},
	},
	lua_ls = {
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
	bashls = { settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } } },
	buf_ls = {},
	tinymist = { settings = { formatterMode = "typstyle", exportPdf = "never", semanticTokens = "disable" } },
	html = { filetypes = { "html", "templ" } },
	graphql = { filetypes = { "graphql", "gql", "svelte", "astro", "vue" } },
	emmet_ls = {
		filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	},
	svelte = {},
	tailwindcss = {},
	marksman = {},
	neocmake = {},
	dockerls = {},
	docker_compose_language_service = {},
}

for name, config in pairs(servers) do
	config.capabilities = capabilities
	config.on_attach = on_attach
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

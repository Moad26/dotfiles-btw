# Neovim: coding first

Requires **Neovim 0.12+**. Plugins use native `vim.pack`; language servers,
formatters, linters, `lazygit`, `fzf`, `rg`, and clipboard tools come from Nix.
Launch Neovim from the project's direnv/devenv shell so it inherits its tools.

## What stays

- Native LSP with nvim-lspconfig server defaults and the existing server settings.
- Blink completion, friendly-snippets using native `vim.snippet`, and lazydev.
  Blink uses its Lua matcher, avoiding a downloaded native binary on NixOS.
- Markdown dictionary completion uses `blink-cmp-dictionary` after two characters.
  Word lists come from `dictionary/*.dict`, with one word per line.
  `eng.dict` is ready; the current `fr.dict` contains a README and needs a real word list.
- Tree-sitter highlighting, indentation, and native folds. Missing supported
  parsers install on filetype detection; parser errors remain visible.
- Conform with the existing format-on-save pipelines: Python Ruff fixes/imports/
  formatting; Go goimports/gofumpt/golines (120 columns); Prettier (100 columns,
  two spaces); clang-format (Google), and the other configured formatters.
- Standalone lint checks **on save or manually**, rather than on every insert exit
  and buffer entry. LSP diagnostics still update independently.
- fzf-lua, Oil, Gitsigns, mini text objects/surround/pairs/key hints, auto tags,
  Tree-sitter-aware comments, and tmux navigation.
- `uv.nvim` automatic `.venv` activation. Its package-management/run shortcuts and
  activation notifications are disabled; use the project shell for those tasks.
- All **50 theme repositories**, their settings, the theme picker, and remembered
  colorscheme. Theme dependencies are included in the native package list.
- System clipboard, persistent undo, relative numbers, and familiar editing keys.

## Visual layer

The default `mini.statusline` setup replaces custom Lualine configuration;
it is included in the existing `mini.nvim` package.
The bundled undo tree replaces the external undo-tree plugin. The existing
experimental `vim._core.ui2` message/command-line UI and rounded borders remain.
Use `:messages` to review notifications.

There is no dashboard, sidebar explorer, indent/scope decoration, custom
notification layer, debug-print override, or dedicated zen/terminal wrapper.
LazyGit opens in a native terminal tab and closes it after a successful exit.
Failed exits stay visible; use `<C-\><C-n>` then `:q` to close the tab.
Ordinary terminals can use `:terminal`.

Flash, Diffview, extra Git pickers, Go helper commands, Neotest, Obsidian,
VimTeX, Typst preview, rendered Markdown, and colorizer
integration were removed from this coding-focused setup. Plain Markdown/Typst
editing, configured LSPs, formatting, and command-line tools remain available.
LSP document colors are Neovim-native but depend on server support.

## Main keys

Leader is **Space**. Existing native LSP keys include `K` (hover), `grn` (rename),
`gra` (code actions), and `[d` / `]d` (diagnostics).

| Key                                        | Action                                                               |
| ------------------------------------------ | -------------------------------------------------------------------- |
| `Ctrl-p`                                   | Find files                                                           |
| `<leader>fg` / `<leader><leader>`          | Search content / recent files                                        |
| `-`                                        | Oil parent directory; edit entries and save to apply file operations |
| `gd` / `gr` / `gi` / `gt`                  | Definitions / references / implementations / types                   |
| `<leader>ds` / `<leader>dd` / `<leader>dx` | Symbols / file / workspace diagnostics                               |
| `<leader>gf`                               | Format file or visual selection                                      |
| `<leader>l` / `<leader>rs`                 | Run linters / restart LSP                                            |
| `<leader>lg`                               | LazyGit in a terminal tab                                            |
| `]c` / `[c` / `<leader>gp`                 | Next / previous / preview Git hunk                                   |
| `<leader>gS` / `<leader>gR` / `<leader>gt` | Stage / reset hunk / toggle blame                                    |
| `<leader>ut`                               | Bundled native undo tree                                             |
| `<leader>tc`                               | Switch theme                                                         |
| `<leader>fb` / `<leader>bd` / `<leader>bo` | Pick / close / close other buffers                                   |
| `Ctrl-h/j/k/l`                             | Neovim/tmux pane navigation                                          |

## Packages and checks

`lua/config/packages.lua` lists coding plugins; `lua/plugins/theme.lua` lists
themes. Configuration is ordinary Lua with explicit setup calls in `init.lua`.
First launch prompts to install missing packages. Keep the generated
`nvim-pack-lock.json` in version control for repeatable revisions.

Update with `:lua vim.pack.update()`. Inspect its review buffer, then `:write` to
accept or `:quit` to discard. Tree-sitter parser updates run after plugin updates.
Both `vim.pack` and UI2 are experimental Neovim APIs; this setup targets 0.12.
The old lazy.nvim installation/cache and ignored lockfile are no longer loaded.

From this directory, run the startup/formatting smoke check:

```sh
nvim --headless -u ./init.lua -i NONE -l tests/config.lua
```

For environment problems use `:checkhealth vim.lsp`, `:ConformInfo`, and
`:lua print(vim.env.VIRTUAL_ENV)`. A configured check still needs its executable
on PATH; in particular, install optional `cpplint`/`jsonlint` if you use those checks.

Tests and debugging stay in the terminal: `go test ./...`, `uv run pytest`,
`dlv debug`, or `dlv test`. Learn breakpoints, inspecting values, stepping, and
the call stack first; add a language-specific DAP integration when needed.

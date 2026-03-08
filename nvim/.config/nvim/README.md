# Neovim Configuration

A personal, high-performance Neovim configuration focused on speed, aesthetics, and developer productivity. Built with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Features

- **Fast Startup**: Optimized with `lazy.nvim` module loading.
- **Aesthetics**: Beautiful UI with `noice.nvim`, `lualine`, and custom themes.
- **Intelligent Coding**: Full LSP support with `blink-cmp` for blazing fast auto-completion.
- **Powerful Navigation**: Fast file finding with `fzf-lua` and file tree management with `neo-tree` & `oil.nvim`.
- **Modern Essentials**: Includes `snacks.nvim` for a delightful coding experience.

## Plugins

### UI & Experence

- **theme**: Custom color scheme.
- **lualine**: Status line.
- **buffer_line**: Buffer management.
- **noice**: Experimental UI for messages, cmdline, and popupmenu.
- **winbar**: Custom window bar.
- **ufo**: Modern fold handling.
- **render-markdown**: Markdown rendering in buffer.
- **colorizer**: Color highlighter.
- **which-key**: Keybinding helper.

### LSP & Completion

- **lsp-config**: Native LSP configuration.
- **blink-cmp**: Fast completion engine.
- **formatting**: Auto-formatting (conform.nvim).
- **linting**: Linting support.
- **lazydev**: Lua development support.
- **tiny-code-actions**: Unobtrusive code actions.
- **trouble**: Pretty diagnostics list.

### Navigation

- **fzf**: Fuzzy finder.
- **neo-tree**: File explorer tree.
- **oil**: File explorer as a buffer.
- **harpoon**: Quick file navigation.
- **noclip**: Clipboard history.

### Languages & Tools

- **Python**:
  - `uv.nvim`: Integration with `uv`.
  - `venv-selector`: Virtual environment switching.
- **Go**: `go-nvim`.
- **LaTeX**: `vimtex`.
- **Typst**: `typst-preview`.
- **Git**: `lazygit-nvim` & `git-stuff`.
- **Utils**: `tmux` integration, `undo-tree`, `spectre` (search & replace), `surround`, `autopairs`, `autotag`.

Lazy.nvim will automatically bootstrap and install all plugins on first launch.

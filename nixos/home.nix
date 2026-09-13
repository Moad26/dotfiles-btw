{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  symlink = config.lib.file.mkOutOfStoreSymlink;

  configs = {
    # btop      = "btop/.config/btop";
    # fastfetch = "fastfetch/.config/fastfetch";
    # fish      = "fish/.config/fish";
    # foot      = "foot/.config/foot";
    # ghostty   = "ghostty/.config/ghostty";
    # kitty     = "kitty/.config/kitty";
    # lazygit   = "lazygit/.config/lazygit";
    # mpv       = "mpv/.config/mpv";
    # niri      = "niri/.config/niri";
    nvim      = "nvim/.config/nvim";
    # scripts   = "scripts/.config/scripts";
    # swaylock  = "swaylock/.config/swaylock";
    # swaync    = "swaync/.config/swaync";
    # tmux      = "tmux/.config/tmux";
    # waybar    = "waybar/.config/waybar";
    # wofi      = "wofi/.config/wofi";
    # yazi      = "yazi/.config/yazi";
    # zed       = "zed/.config/zed";
  };
in
{
  home.username = "mouaad";
  home.homeDirectory = "/home/mouaad";
  home.stateVersion = "26.05";

  # ── User packages ────────────────────────────────────────────
  # Things that are yours, not system-wide
  home.packages = with pkgs; [
    # terminal tools
    kitty
    lazygit
    neovim
    btop
    ripgrep
    fd
    fzf
    zoxide
    eza
    bat
    tree
    unzip
    jq

    # dev
    direnv          # auto-loads nix dev shells on cd
    gh              # GitHub CLI

    # apps
    antigravity
    vscodium
    obsidian
    telegram-desktop
    vlc
    firefox         # or any browser you use

    gcc

    # Go (LSP, linter, formatters, debugger)
    gopls
    golangci-lint
    gofumpt
    gotools     # provides goimports
    golines
    delve

    # Python (LSP, linter/formatter, debugger)
    basedpyright
    ruff
    tree-sitter
  luarocks

  lua-language-server
  clang-tools
  vscode-langservers-extracted
  typescript-language-server
  bash-language-server
  marksman
  buf
  tinymist
  tailwindcss-language-server
  svelte-language-server
  emmet-language-server
  docker-compose-language-service
  dockerfile-language-server

  prettier
  stylua
  shfmt
  taplo
  typstyle

  eslint_d
  shellcheck
  hadolint
  markdownlint-cli

  zathura

    # optional: nix dev shell helper
    nix-direnv
  ];

  # programs.neovim = {
  #   defaultEditor = true; # Sets the $EDITOR environment variable
  #   };

  programs.git = {
  enable = true;
  settings = {
    user.name = "Moad26";
    user.email = "moad2632005@gmail.com";
    init.defaultBranch = "main";
    pull.rebase = false;
  };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = symlink "${dotfiles}/${subpath}";
    # recursive = true;
  }) configs;
  programs.home-manager.enable = true;
}

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
    lazygit
    # neovim
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

    # optional: nix dev shell helper
    nix-direnv
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true; # Sets the $EDITOR environment variable
    
    extraPackages = with pkgs; [
      # --- Treesitter Requirements ---
      gcc
      gnumake
      tree-sitter

      # --- Language Servers (LSPs) ---
      gopls
      clang-tools
      basedpyright
      typescript-language-server
      vscode-langservers-extracted
      lua-language-server
      bash-language-server
      tinymist
      marksman
      dockerfile-language-server-nodejs
      docker-compose-language-service
      tailwindcss-language-server
      buf

      # --- Formatters ---
      prettier
      stylua
      shfmt
      gofumpt
      gotools
      golines
      taplo

      # --- Linters ---
      golangci-lint
      ruff
      eslint_d
      cpplint
      jsonlint
      markdownlint-cli
      shellcheck
      hadolint

    ];
    };

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
    recursive = true;
  }) configs;
  programs.home-manager.enable = true;
}

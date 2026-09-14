{ config, pkgs, inputs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  symlink = config.lib.file.mkOutOfStoreSymlink;

  configs = {
    # btop      = "btop/.config/btop";
    # fastfetch = "fastfetch/.config/fastfetch";
    # fish      = "fish/.config/fish";
    foot      = "foot/.config/foot";
    # ghostty   = "ghostty/.config/ghostty";
    kitty     = "kitty/.config/kitty";
    # lazygit   = "lazygit/.config/lazygit";
    # mpv       = "mpv/.config/mpv";
    niri      = "niri/.config/niri";
    nvim      = "nvim/.config/nvim";
    scripts   = "scripts/.config/scripts";
    # swaylock  = "swaylock/.config/swaylock";
    swaync    = "swaync/.config/swaync";
    # tmux      = "tmux/.config/tmux";
    waybar    = "waybar/.config/waybar";
    # wofi      = "wofi/.config/wofi";
    # yazi      = "yazi/.config/yazi";
    # zed       = "zed/.config/zed";
    wallust = "wallust/.config/wallust";
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
    wallust
    kitty
    foot
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
    inputs.fsel.packages.${pkgs.system}.default
    awww

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

    #something ig
    waybar
    swaynotificationcenter 
    swayidle
    swaylock
    gammastep
    foot
    grim                   
    slurp                 
    swappy                

    gcc

    # Go (LSP, linter, formatters, debugger)
    nil
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
 programs.fish = {
  enable = true;
  interactiveShellInit = ''
    set -g fish_greeting
    set -g fish_key_bindings fish_hybrid_key_bindings
    bind \cp up-or-search
    bind \cn down-or-search
  '';
  shellAbbrs = {
    ls = "eza --color --icons --group-directories-first";
    ll = "eza -la --icons --group-directories-first";
    v = "nvim";
    c = "clear";
    cat = "bat";
    k = "kubectl";
    nrs = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos#legion";
  };
};

programs.starship.enable = true;   # auto-adds fish integration, no manual `source`
programs.zoxide.enable = true;     # same — enableFishIntegration defaults to true
programs.fzf.enable = true;

home.sessionVariables = {
  FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";
};

home.sessionPath = [
  "$HOME/go/bin"
  "$HOME/.config/scripts"
  "$HOME/.local/bin"
  "$HOME/.krew/bin"
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

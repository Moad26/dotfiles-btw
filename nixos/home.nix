{ config, pkgs, ... }:

{
  home.username = "mouaad";
  home.homeDirectory = "/home/mouaad";
  home.stateVersion = "26.05";

  # ── User packages ────────────────────────────────────────────
  # Things that are yours, not system-wide
  home.packages = with pkgs; [
    # terminal tools
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
    obsidian
    telegram-desktop
    vlc
    firefox         # or any browser you use

    # optional: nix dev shell helper
    nix-direnv
  ];


  programs.git = {
  enable = true;
  settings = {
    user.name = "Moad26";
    user.email = "moad2632005@gmail.com";
    init.defaultBranch = "main";
    pull.rebase = false;
  };
  };

  programs.home-manager.enable = true;
}

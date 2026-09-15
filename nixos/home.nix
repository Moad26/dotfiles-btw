{
  config,
  pkgs,
  inputs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  symlink = config.lib.file.mkOutOfStoreSymlink;

  configs = {
    # btop      = "btop/.config/btop";
    otter-launcher = "otter-launcher/.config/otter-launcher";
    fastfetch = "fastfetch/.config/fastfetch";
    # fish      = "fish/.config/fish";
    foot = "foot/.config/foot";
    # ghostty   = "ghostty/.config/ghostty";
    kitty = "kitty/.config/kitty";
    # lazygit   = "lazygit/.config/lazygit";
    # mpv       = "mpv/.config/mpv";
    niri = "niri/.config/niri";
    nvim = "nvim/.config/nvim";
    scripts = "scripts/.config/scripts";
    swaylock = "swaylock/.config/swaylock";
    swaync = "swaync/.config/swaync";
    # tmux      = "tmux/.config/tmux";
    waybar = "waybar/.config/waybar";
    # wofi      = "wofi/.config/wofi";
    # yazi      = "yazi/.config/yazi";
    # zed       = "zed/.config/zed";
    wallust = "wallust/.config/wallust";
  };
in
{
  home = {
    username = "mouaad";
    homeDirectory = "/home/mouaad";
    stateVersion = "26.05";

    # ── User packages ────────────────────────────────────────────
    # Things that are yours, not system-wide
    packages = with pkgs; [
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
      fastfetch
      alsa-utils
      chafa
      wl-clipboard
      inputs.otter-launcher.packages.${pkgs.system}.default
      opencode

      # for waybar niri
      brightnessctl
      nwg-displays
      wifitui
      bluetui
      pavucontrol

      # dev
      direnv # auto-loads nix dev shells on cd
      gh

      # apps
      antigravity
      vscodium
      obsidian
      telegram-desktop
      vlc
      firefox
      inputs.zen-browser.packages.${pkgs.system}.default
      proton-vpn
      vesktop

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

      nil
      gopls
      golangci-lint
      gofumpt
      gotools
      golines
      delve

      basedpyright
      ruff
      tree-sitter
      luarocks

      nixfmt
      statix
      deadnix
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

      nix-direnv
    ];

    sessionVariables = {
      FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border";
    };

    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.config/scripts"
      "$HOME/.local/bin"
      "$HOME/.krew/bin"
    ];
  };
  services.cliphist.enable = true;
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
      cb = "cliphist list | fzf | cliphist decode | wl-copy";
    };
  };

  programs.starship.enable = true; # auto-adds fish integration, no manual `source`
  programs.zoxide.enable = true; # same — enableFishIntegration defaults to true
  programs.fzf.enable = true;

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

{
  description = "Mouaad's NixOS config — Legion Pro 7i Gen 9";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # single nixpkgs, not two copies
    };
    fsel.url = "github:Mjoyufull/fsel";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    otter-launcher.url = "github:kuokuo123/otter-launcher";
    lucida-downloader.url = "github:jelni/lucida-downloader";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true; # a separate instance doesn't inherit your nixpkgs.config
      };
    in
    {
      nixosConfigurations.legion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix

          # community hardware module for Legion Pro 7i Gen 9 (16IRX9H)
          nixos-hardware.nixosModules.lenovo-legion-16irx9h

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs pkgs-unstable; };
              users.mouaad = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}

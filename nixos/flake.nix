{
  description = "Mouaad's NixOS config — Legion Pro 7i Gen 9";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # single nixpkgs, not two copies
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }: {
    nixosConfigurations.legion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix

        # community hardware module for Legion Pro 7i Gen 9 (16IRX9H)
        # handles kernel params, power quirks, PRIME config
        nixos-hardware.nixosModules.lenovo-legion-16irx9h

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mouaad = import ./home.nix;
        }
      ];
    };
  };
}

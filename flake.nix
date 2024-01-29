{
  description = "Dave's NixOS Flake";
  nixConfig = {
    # enable cachix binary caching
    trusted-users = [ "dave" ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nix user repository
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # my own custom nvim flake so it can be installed as a normal pkg
    dave-nvim-flake = {
      url = "github:dczmer/dave-nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ { self, nixpkgs, nur, home-manager, dave-nvim-flake, ...}: {
    nixosConfigurations = {
      # Main desktop
      "lucky" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # import configuration.nix here, so that the old
          # configuration file can still take effect.
          ./hosts/lucky/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs;
            home-manager.users.dave = import ./home/lucky.nix;
          }
        ];
      };

      # personal laptop
      "marvin" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # import configuration.nix here, so that the old
          # configuration file can still take effect.
          ./hosts/marvin/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs;
            home-manager.users.dave = import ./home/marvin.nix;
          }
        ];
      };

      # Home file server
      "guinness" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # import configuration.nix here, so that the old
          # configuration file can still take effect.
          ./hosts/guinness/configuration.nix
          # no home-manager for this server
        ];
      };
    };
  };
}

{
  description = "Nix machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home.url = "github:nix-community/home-manager/release-24.05";
    home.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    home,
    nixpkgs,
    nixpkgs-unstable,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (_: _: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    };
  in {
    nixosConfigurations.garoh = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      inherit system;
      modules = [
        home.nixosModules.home-manager
        ./machines/garoh/configuration.nix
      ];
    };
    nixosConfigurations.imil = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      inherit system;
      modules = [
        home.nixosModules.home-manager
        ./machines/imil/configuration.nix
      ];
    };
    nixosConfigurations.vale = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      inherit system;
      modules = [
        home.nixosModules.home-manager
        ./machines/vale/configuration.nix
      ];
    };
  };
}

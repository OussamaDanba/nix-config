{
  description = "Nix machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home.url = "github:nix-community/home-manager/release-24.11";
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
    myNixosSystem = hostname:
      nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [
          home.nixosModules.home-manager
          ./machines/${hostname}/configuration.nix
        ];
      };
  in {
    nixosConfigurations = {
      garoh = myNixosSystem "garoh";
      imil = myNixosSystem "imil";
      vale = myNixosSystem "vale";
    };
  };
}

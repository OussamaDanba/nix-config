{
  description = "Nix machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home.url = "github:nix-community/home-manager/release-23.11";
    home.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    home,
    nixpkgs,
  }: {
    nixosConfigurations.imil = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home.nixosModules.home-manager
        ./machines/imil/configuration.nix
      ];
    };
    nixosConfigurations.prox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home.nixosModules.home-manager
        ./machines/prox/configuration.nix
      ];
    };
    nixosConfigurations.vale = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home.nixosModules.home-manager
        ./machines/vale/configuration.nix
      ];
    };
  };
}

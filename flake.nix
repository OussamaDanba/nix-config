{
  description = "Nix machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home.url = "github:nix-community/home-manager/release-22.11";
    home.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    home,
    nixpkgs,
  }: {
    nixosConfigurations.sothatwemaybefree = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home.nixosModules.home-manager
        ./machines/sothatwemaybefree/configuration.nix
      ];
    };
    nixosConfigurations.danba-oussama-pqshield = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home.nixosModules.home-manager
        ./machines/danba-oussama-pqshield/configuration.nix
      ];
    };
  };
}

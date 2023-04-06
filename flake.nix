{
  description = "O Danba's awesome nix configuration";

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
        ./configuration.nix
      ];
    };
  };
}

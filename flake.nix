{
  description = "Nix machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home.url = "github:nix-community/home-manager/release-23.11";
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
    homeConfigurations.lemuria = home.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home-manager/common-cli.nix
        ./home-manager/common-gui.nix
        ./home-manager/dev-tools-cli.nix
        ./home-manager/gnome-extensions.nix
        {
          xsession.enable = true;
          programs.home-manager.enable = true;
          home = {
            username = "odanba";
            homeDirectory = "/home/odanba";
            packages = with pkgs; [
              google-chrome
              htop
              python3Packages.pyserial
              remmina
              slack
              sshfs
            ];

            stateVersion = "23.11";
          };

          programs.git = {
            userEmail = "oussama.danba@pqshield.com";
            userName = "Oussama Danba";
          };
        }
      ];
    };
  };
}

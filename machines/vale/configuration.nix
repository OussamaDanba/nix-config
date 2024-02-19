{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false; # Default is insecure.
        memtest86.enable = true;
        configurationLimit = 10;
      };
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };
  };

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
  };
  networking.hostName = "vale";

  # Programs
  home-manager.users.odanba = {pkgs, ...}: {
    imports = [
      ../../home-manager/common-cli.nix
      ../../home-manager/dev-tools-cli.nix
    ];

    home = {
      packages = with pkgs; [
      ];

      stateVersion = "23.11";
    };

    programs.git = {
      userEmail = "oussama@danba.nl";
      userName = "Oussama Danba";
    };
  };

  system.stateVersion = "23.11";
}

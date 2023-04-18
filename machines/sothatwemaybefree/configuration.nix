{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../gnome.nix
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
      timeout = 3;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel"];
  };
  networking.hostName = "sothatwemaybefree";

  # Programs
  home-manager.users.odanba = {pkgs, ...}: {
    imports = [
      ../../home-manager/common-cli.nix
      ../../home-manager/common-gui.nix
      ../../home-manager/gnome-extensions.nix
    ];

    home = {
      packages = with pkgs; [
        discord
        google-drive-ocamlfuse
        lutris
        qbittorrent
        # ascension
        appimage-run
        dxvk
        mono
        wget
        winetricks
        wineWowPackages.waylandFull
      ];

      stateVersion = "22.11";
    };

    xdg.configFile."discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';

    programs.git = {
      userEmail = "oussama@danba.nl";
      userName = "Oussama Danba";
    };
  };

  programs.steam.enable = true;

  system.stateVersion = "22.11";
}
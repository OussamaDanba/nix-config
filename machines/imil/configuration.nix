{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../extras/audio.nix
    ../../extras/common.nix
    ../../extras/cups.nix
    ../../extras/gnome.nix
    ../../extras/wireshark.nix
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
      efi.efiSysMountPoint = "/boot/efi";
    };
    supportedFilesystems = ["ntfs"];
  };

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
  };
  networking.hostName = "imil";

  # Programs
  home-manager.users.odanba = {pkgs, ...}: {
    imports = [
      ../../home-manager/common-cli.nix
      ../../home-manager/common-gui.nix
      ../../home-manager/dev-tools-cli.nix
      ../../home-manager/gnome-extensions.nix
    ];

    home = {
      packages = with pkgs; [
        appimage-run
        ardour
        dxvk
        google-drive-ocamlfuse
        lutris
        nvtopPackages.amd
        prismlauncher
        qbittorrent
        unstable.vesktop
        winetricks
        wineWowPackages.waylandFull
      ];

      stateVersion = "22.11";
    };

    programs.git = {
      userEmail = "oussama@danba.nl";
      userName = "Oussama Danba";
    };
  };

  programs.steam.enable = true;

  system.stateVersion = "22.11";
}

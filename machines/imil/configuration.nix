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
    ../../extras/sunshine.nix
  ];

  # services.unifi.enable = true;
  # services.unifi.openFirewall = true;
  # services.unifi.unifiPackage = pkgs.unifi;
  # services.unifi.mongodbPackage = pkgs.mongodb-ce;

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
      efi.efiSysMountPoint = "/boot";
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
      ../../home-manager/cursor.nix
      ../../home-manager/dev-tools-cli.nix
      ../../home-manager/gnome-extensions.nix
    ];

    home = {
      packages = with pkgs; [
        ardour
        dxvk
        google-drive-ocamlfuse
        lutris
        nvtopPackages.amd
        prismlauncher
        qbittorrent
        vesktop
        winetricks
        wineWowPackages.waylandFull
        mangohud
        gimp
        darktable
        godot
      ];

      stateVersion = "25.05";
    };
  };

  programs.steam.enable = true;

  services.resolved = {
    enable = true;
    dnsovertls = "true";
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8
      FallbackDNS=1.0.0.1 8.8.4.4
      MulticastDNS=no
    '';
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    openFirewall = true;
    host = "0.0.0.0";
  };
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    port = 11111;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      WEBUI_AUTH = "False";
    };
  };

  system.stateVersion = "25.05";
}

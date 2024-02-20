{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../extras/common.nix
    ../../extras/openssh.nix
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

  # Run powertop autotune on startup
  powerManagement.powertop.enable = true;

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel"];
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
        powertop
      ];

      stateVersion = "23.11";
    };

    programs.git = {
      userEmail = "oussama@danba.nl";
      userName = "Oussama Danba";
    };
  };

  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  systemd = {
    packages = [pkgs.qbittorrent-nox];
    services."qbittorrent-nox@odanba" = {
      overrideStrategy = "asDropin";
      wantedBy = ["multi-user.target"];
    };
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.qbittorrent-nox
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # qbittorrent-nox
      8080
    ];
  };

  system.stateVersion = "23.11";
}

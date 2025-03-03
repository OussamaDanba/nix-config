{
  config,
  pkgs,
  lib,
  ...
}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    useDHCP = lib.mkDefault true;
  };

  home-manager.useGlobalPkgs = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  services = {
    # Enable Avahi for detection of hosts
    avahi = {
      enable = true;
      ipv4 = true;
      nssmdns4 = true;
      ipv6 = true;
      nssmdns6 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };

    # Configure keymap in X11 but don't decide whether we use X or not.
    xserver.xkb = {
      layout = "us";
      variant = "euro";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      htop
      wireguard-tools
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}

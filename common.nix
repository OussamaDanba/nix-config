{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    networkmanager.enable = true;
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
    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable Avahi for detection of hosts
    avahi = {
      enable = true;
      nssmdns = true;
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # Configure keymap in X11 but don't decide whether we use X or not.
    xserver = {
      layout = "us";
      xkbVariant = "euro";
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      htop
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.QT_QPA_PLATFORM = "wayland";
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}

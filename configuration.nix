{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # So we can still access windows
  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = true; # Default but make clear that this is insecure.
      memtest86.enable = true;
    };
    timeout = 2;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    hostName = "odanba";
    networkmanager.enable = true;
  };

  # Everything related to locales and keyboard
  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = "nl_NL.UTF-8";
    extraLocaleSettings = { LANGUAGE = "en_US.UTF-8"; };
  };
  console.useXkbConfig = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.gutenprintBin pkgs.brlaser ];
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Enable sound through pulseaudio.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    daemon.config = {
      default-sample-format = "float32le";
      default-sample-rate = 48000;
      alternate-sample-rate = 44100;
      default-sample-channels = 2;
      default-channel-map = "front-left,front-right";
      default-fragments = 2;
      default-fragment-size-msec = 125;
      resample-method = "soxr-vhq";
      enable-lfe-remixing = "no";
      high-priority = "yes";
      nice-level = -11;
      realtime-scheduling = "yes";
      realtime-priority = 9;
      rlimit-rtprio = 9;
      daemonize = "no";
    };
  };

  # Enable libinput
  services.xserver.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0.0";
  };

  users.users.odanba = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ htop home-manager memtest86-efi ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm = {
        enable = true;
        background = "/etc/nixos/background-image.jpg";
      };
      defaultSession = "none+i3";
    };

    windowManager.i3.enable = true;
    videoDrivers = [ "nvidia" ];
  };

  programs.dconf.enable = true;

  # Don't wait on internet connection so we can boot faster
  systemd.services.NetworkManager-wait-online.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

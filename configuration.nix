{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  hardware.nvidia.modesetting.enable = true;

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = true; # Default but make clear that this is insecure.
        memtest86.enable = true;
        configurationLimit = 10;
      };
      timeout = 3;
      efi.canTouchEfiVariables = true;
    };
    # So we can mount Windows drivers
    supportedFilesystems = [ "ntfs" ];

    # v4l2loopback kernel module to allow for a virtual camera
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];

    # Required to fix xbox wireless controller weirdness
    extraModprobeConfig = "options bluetooth disable_ertm=1";
  };

  fileSystems."/mnt/secondary" = {
    device = "/dev/disk/by-uuid/56FE6022FE5FF8A7";
    fsType = "ntfs";
    mountPoint = "/mnt/secondary";
  };

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    hostName = "odanba";
    networkmanager.enable = true;
  };

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  users.users.odanba = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    htop
    home-manager
    memtest86-efi
    xboxdrv
    openssl
  ];

  # Bluetooth configuration
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Everything related to locales and keyboard
  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = "nl_NL.UTF-8";
    extraLocaleSettings = { LANGUAGE = "en_US.UTF-8"; };
  };
  console.useXkbConfig = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";

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

  # Enable libinput
  services.xserver.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0.0";
  };

  # Enable sound through pulseaudio.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Configuration that increases the sound quality noticeably
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

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers =
    [ pkgs.gutenprint pkgs.gutenprintBin pkgs.brlaser ];
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  programs = {
    dconf.enable = true;
    steam.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

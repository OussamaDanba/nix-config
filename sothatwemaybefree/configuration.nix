{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
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
    # So we can mount Windows drives
    supportedFilesystems = ["ntfs"];
  };

  networking = {
    hostName = "sothatwemaybefree";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

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
    xserver = {
      enable = true;
      # Configure keymap in X11
      layout = "us";
      xkbVariant = "euro";
      # Enable GNOME
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      desktopManager.xterm.enable = false;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable Avahi for detection of hosts
    avahi = {
      enable = true;
      nssmdns = true;
    };

    openssh = {
      enable = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
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

  # Enable touchpad support (enabled default in most desktopManager).

  users.defaultUserShell = pkgs.fish;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.odanba = {pkgs, ...}: {
    home.stateVersion = "22.11";
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        ${pkgs.starship}/bin/starship init fish | source
      '';
      plugins = with pkgs.fishPlugins; [
        (with fzf-fish; {inherit name src;})
        (with done; {inherit name src;})
      ];
      shellAliases = {
        lg = "lazygit";
        e = "exa -abhl --git";
        ls = "exa";
        l = "e";
      };
    };
    home = {
      packages = with pkgs;
        [
          alejandra
          atool
          discord
          fd
          firefox
          google-drive-ocamlfuse
          helvum
          ripgrep
          keepassxc
          libreoffice-fresh
          lutris
          qbittorrent
          vlc
          # ascension wow
          wineWowPackages.waylandFull
          winetricks
          mono
          dxvk
          wget
          appimage-run
        ]
        ++ (with pkgs.gnomeExtensions; [
          appindicator
          dash-to-panel
          just-perfection
        ]);
    };
    xdg.configFile."discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions;
        [
          bbenoist.nix
          kamadorueda.alejandra
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "hyper-term-theme";
            publisher = "hsnazar";
            version = "0.3.0";
            sha256 = "sha256-EIRsvvjns3FX4fTom3hHtQALEnaWf+jxakza2HTyPcw=";
          }
        ];
    };

    programs.exa.enable = true;
    programs.lazygit = {
      enable = true;
      settings = {gui.showCommandLog = false;};
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
      userEmail = "oussama@danba.nl";
      userName = "Oussama Danba";
      extraConfig = {init.defaultBranch = "main";};
    };

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      # Fish integration is disabled in favour of the fzf fish plugin. As per this statement from that project's README:
      # Note that the fzf utility has its own out-of-the-box fish package. What
      # sets this package apart is that it has a couple more integrations, most
      # notably tab completion, and will probably be updated more frequently. They
      # are not compatible so either use one or the other.
      #enableFishIntegration = true;
    };
  };

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    htop
  ];

  environment.gnome.excludePackages =
    (with pkgs; [
      epiphany
      gnome-console
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      geary
      gnome-calendar
      gnome-characters
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-weather
      totem
      yelp
    ]);

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "22.11";
}

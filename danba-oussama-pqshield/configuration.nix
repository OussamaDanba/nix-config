{
  config,
  pkgs,
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
  };

  networking = {
    hostName = "danba-oussama-pqshield";
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "euro";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
        # Om 't af te leren
        ls = "false";
        l = "false";
        e = "exa -abhl --git";
      };
    };
    home = {
      packages = with pkgs;
        [
          alejandra
          atool
          fd
          firefox
          helvum
          ripgrep
          libreoffice-fresh
        ]
        ++ (with pkgs.gnomeExtensions; [
          appindicator
          dash-to-panel
          just-perfection
        ]);
    };
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

  services.openssh = {
    enable = false;
    passwordAuthentication = true;
    kbdInteractiveAuthentication = true;
    #permitRootLogin = "yes";
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  system.stateVersion = "22.11";
}

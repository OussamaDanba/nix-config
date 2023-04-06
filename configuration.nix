{
  config,
  pkgs,
  ...
}: let
  # Hyper colors
  primary_background = "#000000";
  primary_foreground = "#FFFFFF";
  cursor_text = "#F81CE5";
  cursor_cursor = "#FFFFFF";
  normal_black = "#000000";
  normal_red = "#FE0100";
  normal_green = "#33FF00";
  normal_yellow = "#FEFF00";
  normal_blue = "#0066FF";
  normal_magenta = "#CC00FF";
  normal_cyan = "#00FFFF";
  normal_white = "#D0D0D0";
  bright_black = "#808080";
  bright_red = "#FE0100";
  bright_green = "#33FF00";
  bright_yellow = "#FEFF00";
  bright_blue = "#0066FF";
  bright_magenta = "#CC00FF";
  bright_cyan = "#00FFFF";
  bright_white = "#FFFFFF";
in {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = true; # Default but make clear that this is insecure.
        memtest86.enable = true;
        configurationLimit = 20;
      };
      timeout = 3;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.modesetting.enable = true;

  networking = {
    hostName = "sothatwemaybefree";
    networkmanager.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # Enable libinput
  services.xserver.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0.0";
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
          discord
          firefox
          helvum
          keepassxc
          qbittorrent
          vlc
          fd
          atool
          google-drive-ocamlfuse
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

    programs.alacritty = {
      enable = true;
      settings = {
        selection = {save_to_clipboard = true;};
        colors = {
          primary = {
            background = "${primary_background}";
            foreground = "${primary_foreground}";
          };
          cursor = {
            text = "${cursor_text}";
            cursor = "${cursor_cursor}";
          };
          normal = {
            black = "${normal_black}";
            red = "${normal_red}";
            green = "${normal_green}";
            yellow = "${normal_yellow}";
            blue = "${normal_blue}";
            magenta = "${normal_magenta}";
            cyan = "${normal_cyan}";
            white = "${normal_white}";
          };
          bright = {
            black = "${bright_black}";
            red = "${bright_red}";
            green = "${bright_green}";
            yellow = "${bright_yellow}";
            blue = "${bright_blue}";
            magent = "${bright_magenta}";
            cyan = "${bright_cyan}";
            white = "${bright_white}";
          };
        };
        key_bindings = [
          {
            key = "V";
            mods = "Control|Alt";
            mode = "~Vi";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Control|Alt";
            action = "Copy";
          }
          {
            key = "F";
            mods = "Control|Alt";
            mode = "~Search";
            action = "SearchForward";
          }
          {
            key = "B";
            mods = "Control|Alt";
            mode = "~Search";
            action = "SearchBackward";
          }
          {
            key = "C";
            mods = "Control|Alt";
            mode = "Vi|~Search";
            action = "ClearSelection";
          }
          {
            key = "Insert";
            mods = "Alt";
            action = "PasteSelection";
          }
        ];
      };
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

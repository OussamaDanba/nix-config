{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
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
      timeout = 3;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel"];
  };
  networking.hostName = "sothatwemaybefree";

  # Programs
  home-manager.users.odanba = {pkgs, ...}: {
    imports = [
      ../home-manager/alacritty.nix
      ../home-manager/fish.nix
    ];

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

      stateVersion = "22.11";
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
  };

  programs.steam.enable = true;

  # GNOME specific
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    desktopManager.xterm.enable = false;
  };
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

  system.stateVersion = "22.11";
}

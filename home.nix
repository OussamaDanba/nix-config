{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  home.username = "odanba";
  home.homeDirectory = "/home/odanba";

  home.packages = with pkgs; [
    alacritty
    discord
    exa
    fd
    feh
    firefox
    font-awesome
    git
    gnome3.gnome-calculator
    google-drive-ocamlfuse
    i3lock-fancy
    keepass
    libreoffice-fresh
    maim
    nixfmt
    noto-fonts
    noto-fonts-cjk
    pavucontrol
    pcmanfm
    playerctl
    powerline-fonts
    powerline-go
    vlc
    qbittorrent
    xclip
    xdotool
  ];

  fonts.fontconfig.enable = true;

  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    initExtra = ''
      function cd {
        builtin cd "$@" && exa -abhl --git
      }
    '';
    shellAliases = {
      ls = "exa";
      l = "exa -abhl --git";
      con = "home-manager edit";
      update = "sudo nix-channel --update";
      upgrade = "sudo nixos-rebuild switch && home-manager switch";
    };
  };

  programs.powerline-go = {
    enable = true;
    modules = [ "host" "ssh" "cwd" "gitlite" "nix-shell" ];
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "oussama@danba.nl";
    userName = "Oussama Danba";
    extraConfig = { init.defaultBranch = "main"; };
  };

  programs.alacritty = { enable = true; };

  # TODO: Use feh for randomized backgrounds
  programs.feh.enable = true;

  programs.firefox = { enable = true; };

  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      terminal = "alacritty";
      window = {
        border = 1;
        titlebar = false;
      };
      focus = {
        followMouse = false;
        mouseWarping = false;
      };
      modifier = "Mod4";
      startup = [
        {
          command = "google-drive-ocamlfuse ~/Drive";
          always = false;
          notification = false;
        }
        {
          command = "xrandr --output HDMI-0 --primary";
          always = false;
          notification = false;
        } # HACK: xrandHeads not working properly
      ];
      keybindings =
        let modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+grave" = "exec --no-startup-id pcmanfm";
          "${modifier}+Escape" = "exec --no-startup-id i3lock-fancy";
          "${modifier}+b" = "border toggle";
          "${modifier}+shift+t" = "move scratchpad";
          "${modifier}+t" = "scratchpad show";
          "Print" =
            "exec --no-startup-id maim --select | xclip -selection clipboard -t image/png";
          "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
          "XF86AudioStop" = "exec --no-startup-id playerctl stop";
          "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
          "XF86AudioNext" = "exec --no-startup-id playerctl next";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
          "XF86AudioLowerVolume" =
            "exec --no-startup-id pactl set-sink-volume 0 -2%";
          "XF86AudioRaiseVolume" =
            "exec --no-startup-id pactl set-sink-volume 0 +2%";
        };
      #bars = [{
      #  fonts = [ "FontAwesome 10" "Noto Sans Mono 10" ];
      #}];
      fonts = [ "FontAwesome 10" "Noto Sans Mono 10" ];
    };
  };

  # TODO: Use Noto fonts if possible?
  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        background = "#000000"; # "#181818";
        foreground = "#000000"; # "#E3C7AF";
        geometry = "300x5-25+25";
        font = "Noto Sans Mono";
        sort = true;
        alignment = "center";
      };
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
    extraOptions = ''
      xrender-sync-fence = true;
      glx-no-stencil = true;
    '';
  };
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}

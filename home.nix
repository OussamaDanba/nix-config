{ config, pkgs, lib, ... }:

let
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
    vscode
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

  programs.alacritty = {
    enable = true;
    settings = {
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
    };
  };

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
          command = "autorandr --change";
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

  programs.autorandr = {
    enable = true;

    profiles = {
      pc = {
        fingerprint = {
          HDMI-0 = "*";
          DP-0 = "*";
        };
        config = {
          HDMI-0 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-0 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
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
        font = "Noto Sans Mono 11";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        sort = true;
        indicate_hidden = true;
        alignment = "center";
        bounce_freq = 0;
        show_age_threshold = 30;
        word_wrap = true;
        ignore_newline = false;
        geometry = "300x5-25+25";
        transparency = 0;
        idle_threshold = 120;
        max_icon_size = 60;
        corner_radius = 6;
        sticky_history = true;
        line_height = 0;
        separator_height = 5;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "#00000000";
        startup_notification = false;
        frame_width = 1;
        frame_color = "${normal_black}";
      };

      urgency_low = {
        background = "${normal_green}";
        foreground = "${normal_black}";
        timeout = 5;
      };

      urgency_normal = {
        background = "${normal_yellow}";
        foreground = "${normal_black}";
        timeout = 20;
      };

      urgency_critical = {
        background = "${normal_red}";
        foreground = "${normal_black}";
        timeout = 0;
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

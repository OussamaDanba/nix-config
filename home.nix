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
    clementine
    discord
    drive
    exa
    fd
    feh
    firefox
    font-awesome
    git
    gnome3.gnome-calculator
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
    qbittorrent
    rofi
    vlc
    vscode
    xclip
    xdotool
  ];

  fonts.fontconfig.enable = true;

  programs = {
    bash = {
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

    powerline-go = {
      enable = true;
      modules = [ "host" "ssh" "cwd" "gitlite" "nix-shell" ];
    };

    git = {
      enable = true;
      lfs.enable = true;
      userEmail = "oussama@danba.nl";
      userName = "Oussama Danba";
      extraConfig = { init.defaultBranch = "main"; };
    };

    alacritty = {
      enable = true;
      settings = {
        font = { size = 11.0; };
        selection = { save_to_clipboard = true; };
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

    rofi = {
      enable = true;
      colors = {
        window = {
          background = "${primary_background}";
          border = "${normal_blue}";
          separator = "${normal_red}";
        };

        rows = {
          normal = {
            background = "${primary_background}";
            foreground = "${primary_foreground}";
            backgroundAlt = "${primary_background}";
            highlight = {
              background = "${primary_foreground}";
              foreground = "${primary_background}";
            };
          };
        };
      };
      font = "Noto Sans Mono 14";
    };

    autorandr = {
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

    i3status-rust = {
      enable = true;
      bars.default = {
        settings = {
          theme = {
            name = "native";
            overrides = {
              idle_bg = "${primary_background}";
              idle_fg = "${primary_foreground}";
              info_bg = "${normal_blue}";
              info_fg = "${primary_foreground}";
              warning_bg = "${normal_yellow}";
              warning_fg = "${primary_background}";
              good_bg = "${normal_green}";
              good_fg = "${primary_background}";
              critical_bg = "${normal_red}";
              critical_fg = "${primary_foreground}";
            };
          };
          icons = { name = "awesome5"; };
        };
        blocks = [
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "used";
            unit = "GB";
            interval = 60;
            warning = 80.0;
            alert = 90.0;
            format = " {used}/{total} {unit}";
          }
          {
            block = "memory";
            format_mem = "{Mum}/{MTm} ({Mup}%)";
            format_swap = "{SUm}/{STm} ({SUp}%)";
          }
          {
            block = "nvidia_gpu";
            label = "";
          }
          {
            block = "cpu";
            format = "{barchart} {utilization} {frequency}";
          }
          {
            block = "net";
            format = "{ip}";
            # TODO: Enable when package has been updated (only on upstream right now)
            #format_alt = "{speed_up} {speed_down}";
          }
          {
            block = "weather";
            format = "{weather} {temp}°C {humidity}% RH";
            service = {
              name = "openweathermap";
              api_key = "f2308aba9fb59395c4466234d0ab348b";
              city_id = "2750053";
              units = "metric";
            };
          }
          {
            block = "sound";
            step_width = 1;
          }
          {
            block = "time";
            format = "%Y-%m-%d %H:%M";
          }
        ];
      };
    };

    feh.enable = true;
    firefox.enable = true;
  };

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
          # HACK: xrandHeads not working properly
          command = "autorandr --change";
          always = false;
          notification = false;
        }
        {
          command = "feh --randomize --bg-fill ~/Pictures/Backgrounds/*";
          always = false;
          notification = false;
        }
      ];
      menu = ''
        "${pkgs.rofi}/bin/rofi -modi window,drun,combi -show combi -icon-theme \\"Arc\\" -show-icons"
      '';
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
      bars = [{
        colors = {
          background = "${primary_background}";
          bindingMode = {
            border = "${normal_red}";
            background = "${normal_red}";
            text = "${normal_black}";
          };
          focusedWorkspace = {
            border = "${normal_blue}";
            background = "${normal_blue}";
            text = "${normal_black}";
          };
          inactiveWorkspace = {
            border = "${primary_background}";
            background = "${primary_background}";
            text = "${primary_foreground}";
          };
        };
        fonts = [ "FontAwesome 10" "Noto Sans Mono 10" ];
        statusCommand =
          "i3status-rs ~/.config/i3status-rust/config-default.toml";
      }];
      fonts = [ "FontAwesome 10" "Noto Sans Mono 10" ];
    };
  };

  services = {
    dunst = {
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
          geometry = "400x5-25+25";
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

    picom = {
      enable = true;
      vSync = true;
      extraOptions = ''
        xrender-sync-fence = true;
        glx-no-stencil = true;
      '';
    };
  };

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

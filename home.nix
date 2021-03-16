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
    firefox
    git
    google-drive-ocamlfuse
    i3lock-fancy
    keepass
    maim
    pavucontrol
    pcmanfm
    playerctl
    vlc
    qbittorrent
    xclip
    xdotool
  ];

  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    shellAliases = {
      ls = "exa";
      l = "exa -abghHlS --git";
      con = "home-manager edit";
      update = "sudo nix-channel --update";
      upgrade = "sudo nixos-rebuild switch && home-manager switch";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "oussama@danba.nl";
    userName = "Oussama Danba";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.alacritty = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
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
        { command = "google-drive-ocamlfuse ~/Drive"; always = false; notification = false; }
      ];
      keybindings =
       let modifier = config.xsession.windowManager.i3.config.modifier;
       in lib.mkOptionDefault {
        "${modifier}+grave" = "exec pcmanfm";
        "${modifier}+Escape" = "exec i3lock-fancy";
        "${modifier}+b" = "border toggle";
        "${modifier}+shift+t" = "move scratchpad";
        "${modifier}+t" = "scratchpad show";
        "Print" = "exec maim --select | xclip -selection clipboard -t image/png";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -2%";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +2%";
      };
      bars = [{
        fonts = [ "FontAwesome 9" "Noto Sans Mono 9" ];
      }];
      fonts = [ "FontAwesome 9" "Noto Sans Mono 9" ];
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

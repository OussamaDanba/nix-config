{
  config,
  pkgs,
  ...
}: {
  home-manager.users.odanba = {pkgs, ...}: {
    programs.alacritty = {
      enable = true;
      settings = {
        selection = {save_to_clipboard = true;};
        colors = {
          primary = {
            background = "#000000";
            foreground = "#FFFFFF";
          };
          cursor = {
            text = "#F81CE5";
            cursor = "#FFFFFF";
          };
          normal = {
            black = "#000000";
            red = "#FE0100";
            green = "#33FF00";
            yellow = "#FEFF00";
            blue = "#0066FF";
            magenta = "#CC00FF";
            cyan = "#00FFFF";
            white = "#D0D0D0";
          };
          bright = {
            black = "#808080";
            red = "#FE0100";
            green = "#33FF00";
            yellow = "#FEFF00";
            blue = "#0066FF";
            magent = "#CC00FF";
            cyan = "#00FFFF";
            white = "#FFFFFF";
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
  };
}

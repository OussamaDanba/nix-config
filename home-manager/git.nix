{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {init.defaultBranch = "main";};
  };

  programs.lazygit = {
    enable = true;
    settings = {gui.showCommandLog = false;};
  };
}

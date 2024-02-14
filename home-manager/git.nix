{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {init.defaultBranch = "main";};
    ignores = [".vscode" ".direnv"];
  };

  programs.lazygit = {
    enable = true;
    settings = {gui.showCommandLog = false;};
  };
}

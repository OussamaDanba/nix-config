{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      extraConfig = {init.defaultBranch = "main";};
      user = {
        email = "oussama@danba.nl";
        name = "Oussama Danba";
      };
    };
    ignores = [".vscode" ".direnv"];
  };

  programs.lazygit = {
    enable = true;
    settings = {gui.showCommandLog = false;};
  };
}

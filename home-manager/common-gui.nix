{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    firefox
    helvum
    keepassxc
    libreoffice-fresh
    vlc
  ];
}

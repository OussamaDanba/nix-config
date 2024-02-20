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
    element-desktop
    firefox
    helvum
    jellyfin-media-player
    keepassxc
    libreoffice-fresh
    pinta
    vlc
  ];
}

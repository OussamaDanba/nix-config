{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./git.nix
  ];

  programs.eza.enable = true;

  home.packages = with pkgs; [
    atool
    fd
    file
    pciutils
    python3Full
    python3Packages.pip
    ripgrep
    tree
    unzip
    usbutils
    wireguard-tools
  ];
}

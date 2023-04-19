{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./git.nix
  ];

  programs.exa.enable = true;

  home.packages = with pkgs; [
    atool
    fd
    file
    pciutils
    python3Full
    ripgrep
    tree
    unzip
    usbutils
  ];
}

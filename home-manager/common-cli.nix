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
    pciutils
    python3Full
    ripgrep
    tree
    usbutils
  ];
}

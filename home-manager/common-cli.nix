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
    python3Full
    ripgrep
    tree
  ];
}

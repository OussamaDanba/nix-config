{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bintools
    cmakeCurses
    gdb
    gnumake
  ];
}

{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bintools
    clang-tools
    cmakeCurses
    gdb
    gnumake
    unstable.zig
    unstable.zls
  ];
}

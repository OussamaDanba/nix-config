{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-panel
    just-perfection
  ];
}

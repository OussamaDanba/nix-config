{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    vitals
    workspace-indicator
  ];
}

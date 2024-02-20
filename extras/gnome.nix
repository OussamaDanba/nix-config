{
  config,
  pkgs,
  ...
}: {
  # GNOME specific
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    desktopManager.xterm.enable = false;
  };
  environment.gnome.excludePackages =
    (with pkgs; [
      epiphany
      gnome-console
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      geary
      gnome-calendar
      gnome-characters
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-weather
      totem
      yelp
    ]);
}

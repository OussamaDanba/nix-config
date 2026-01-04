{
  config,
  pkgs,
  ...
}: {
  # GNOME specific
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-calendar
    gnome-characters
    gnome-console
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
    totem
    yelp
  ];
}

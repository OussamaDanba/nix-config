{
  config,
  pkgs,
  ...
}: {
  home.pointerCursor = {
    name = "volantes_cursors";
    package = pkgs.volantes-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk.cursorTheme = {
    name = "volantes_cursors";
    package = pkgs.volantes-cursors;
  };
}

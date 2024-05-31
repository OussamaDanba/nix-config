{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./git.nix
  ];

  programs.eza.enable = true;
  programs.direnv.enable = true;

  home.packages = with pkgs; [
    atool
    fd
    file
    pciutils
    python3Full
    python3Packages.pip
    ripgrep
    tree
    unzip
    usbutils
    wally-cli
  ];

  # programs.helix = {
  #   enable = true;
  #   settings = {
  #     theme = "base16_transparent";
  #     editor = {
  #       line-number = "relative";
  #       cursorline = true;
  #       bufferline = "always";
  #       color-modes = true;
  #       cursor-shape = {
  #         insert = "bar";
  #       };
  #       whitespace = {
  #         render = {
  #           space = "all";
  #           tab = "all";
  #           newline = "none";
  #         };
  #       };
  #       indent-guides = {
  #         render = true;
  #       };
  #       soft-wrap = {
  #         enable = true;
  #       };
  #     };
  #     keys = {
  #       normal = {
  #         "tab" = ":buffer-next";
  #         "S-tab" = ":buffer-previous";
  #       };
  #     };
  #   };
  #   languages = {
  #     language = [
  #       {
  #         name = "nix";
  #         auto-format = true;
  #         formatter = {
  #           command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
  #         };
  #       }
  #     ];
  #   };
  # };
}

{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.wireshark.enable = true;
  environment = {
    systemPackages = with pkgs; [
      wireshark
    ];
  };
}

{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ../../gnome.nix
  ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false; # Default is insecure.
        memtest86.enable = true;
        configurationLimit = 10;
      };
      timeout = 1;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
  };
  networking.hostName = "danba-oussama-pqshield";

  # Programs
  home-manager.users.odanba = {pkgs, ...}: {
    imports = [
      ../../home-manager/common-cli.nix
      ../../home-manager/common-gui.nix
      ../../home-manager/dev-tools-cli.nix
      ../../home-manager/gnome-extensions.nix
    ];

    home = {
      packages = with pkgs; [
        google-chrome
        python3Packages.pyserial
        slack
        sshfs
      ];

      stateVersion = "22.11";
    };

    programs.git = {
      userEmail = "oussama.danba@pqshield.com";
      userName = "Oussama Danba";
    };
  };

  # Virtualbox for Vivado
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["odanba"];

  services.udev.extraRules = ''
    ATTR{idVendor}=="1443", MODE:="666"
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
  '';

  system.stateVersion = "22.11";
}

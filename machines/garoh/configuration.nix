{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../extras/audio.nix
    ../../extras/common.nix
    ../../extras/cups.nix
    ../../extras/gnome.nix
    ../../extras/wireshark.nix
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
    };
  };

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
  };
  networking.hostName = "garoh";

  # Programs
  home-manager.users.odanba = {pkgs, ...}: {
    imports = [
      ../../home-manager/common-cli.nix
      ../../home-manager/common-gui.nix
      ../../home-manager/cursor.nix
      ../../home-manager/dev-tools-cli.nix
      ../../home-manager/gnome-extensions.nix
    ];

    home = {
      packages = with pkgs; [
        vesktop
        nvtopPackages.amd
      ];

      stateVersion = "23.11";
    };
  };

  programs.steam.enable = true;

  services.resolved = {
    enable = true;
    dnsovertls = "true";
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8
      FallbackDNS=1.0.0.1 8.8.4.4
    '';
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      # "systemctl stop/start wg-quick-wg0.service" should work.
      # In practice it doesn't seem to connect afterwards?
      autostart = false;
      address = ["10.27.0.3/32" "fdc9:281f:04d7:9ee9::3/128"];
      dns = ["1.1.1.1" "8.8.8.8"];
      privateKeyFile = "/home/odanba/wireguard-keys/private_key";

      peers = [
        {
          publicKey = "aQ0xUKwN2zlVJrxM5O4w2LsM7V1a8DOYeFqudLZuvx8=";
          presharedKeyFile = "/home/odanba/wireguard-keys/psk";
          allowedIPs = ["0.0.0.0/0" "::/0"];
          endpoint = "thuis.danba.nl:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  system.stateVersion = "23.11";
}

{
  config,
  pkgs,
  ...
}: let
  eth_interface = "enp0s31f6";
in {
  imports = [
    ./hardware-configuration.nix
    ../../extras/common.nix
    ../../extras/openssh.nix
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

  # Run powertop autotune on startup
  powerManagement.powertop.enable = true;

  # User account
  users.users.odanba = {
    isNormalUser = true;
    description = "Oussama Danba";
    extraGroups = ["networkmanager" "wheel"];
  };
  networking.hostName = "vale";

  # Programs
  home-manager.users.odanba = {pkgs, ...}: {
    imports = [
      ../../home-manager/common-cli.nix
      ../../home-manager/dev-tools-cli.nix
    ];

    home = {
      packages = with pkgs; [
        powertop
      ];

      stateVersion = "23.11";
    };

    programs.git = {
      userEmail = "oussama@danba.nl";
      userName = "Oussama Danba";
    };
  };

  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  services.resolved = {
    enable = true;
    dnsovertls = "true";
    extraConfig = ''
      DNS=1.1.1.1 8.8.8.8
      FallbackDNS=1.0.0.1 8.8.4.4
    '';
  };

  systemd = {
    packages = [pkgs.qbittorrent-nox];
    services."qbittorrent-nox@odanba" = {
      overrideStrategy = "asDropin";
      wantedBy = ["multi-user.target"];
    };
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.qbittorrent-nox
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # qbittorrent-nox. Modified from 8080 as Unifi uses it.
      4321
      # Home Assistant
      8123
    ];
    allowedUDPPorts = [
      # wireguard
      51820
    ];
  };

  # For wireguard. Many users will all masquerade behind the same external IP so for
  # this to work we need NAT.
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = eth_interface;
    internalInterfaces = ["wg0"];
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.27.0.1/24" "fdc9:281f:04d7:9ee9::1/64"];
      listenPort = 51820;
      privateKeyFile = "/home/odanba/wireguard-keys/server_private_key";

      # Route wireguard traffic so that users can access the internet.
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.27.0.1/24 -o ${eth_interface} -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ${eth_interface} -j MASQUERADE
      '';

      # Undo the above
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.27.0.1/24 -o ${eth_interface} -j MASQUERADE
        ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o ${eth_interface} -j MASQUERADE
      '';

      peers = [
        # Phone
        {
          publicKey = "KwQgjVSDpC4uYcgSavBVZ34tlJiotFYt8agECVB6BU0=";
          presharedKeyFile = "/home/odanba/wireguard-keys/peer1_psk";
          allowedIPs = ["10.27.0.2/32" "fdc9:281f:04d7:9ee9::2/128"];
        }
        # Garoh
        {
          publicKey = "0Ov1EAujqLZMwuQ+BEByVaDgMIGrFJsD3WiiblAsKwo=";
          presharedKeyFile = "/home/odanba/wireguard-keys/peer2_psk";
          allowedIPs = ["10.27.0.3/32" "fdc9:281f:04d7:9ee9::3/128"];
        }
        # Tablet
        {
          publicKey = "0o1ioIyGTY8fRe0UNLoAzGi0snv+OOYAAs6EXpvJo3M=";
          presharedKeyFile = "/home/odanba/wireguard-keys/peer3_psk";
          allowedIPs = ["10.27.0.4/32" "fdc9:281f:04d7:9ee9::4/128"];
        }
      ];
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = ["home-assistant:/config"];
      environment.TZ = "Europe/Amsterdam";
      # Note: Tag needs to change in order for it to be updated
      image = "ghcr.io/home-assistant/home-assistant:2025.1.3";
      extraOptions = [
        "--network=host"
        # Needed to make DHCP discovery work
        "--cap-add=CAP_NET_RAW"
      ];
    };
  };

  system.stateVersion = "23.11";
}

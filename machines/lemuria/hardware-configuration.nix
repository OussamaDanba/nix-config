{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    # kernelPatches = [
    #   {
    #     name = "gcov-config";
    #     patch = null;
    #     extraConfig = ''
    #       DEBUG_FS y
    #       GCOV_KERNEL y
    #       GCOV_PROFILE_ALL y
    #     '';
    #   }
    # ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/92eb47c5-dc0d-4338-b451-bb87d2c22c85";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd"];
  };

  boot.initrd.luks.devices."luks-0e6f9cbb-1b94-4de6-9854-59655603b406".device = "/dev/disk/by-uuid/0e6f9cbb-1b94-4de6-9854-59655603b406";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D63A-9B2E";
    fsType = "vfat";
  };

  swapDevices = [];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };

    keyboard.zsa.enable = true;
  };
  services.xserver.videoDrivers = ["intel"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

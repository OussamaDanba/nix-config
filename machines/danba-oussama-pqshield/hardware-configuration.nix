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
      availableKernelModules = ["nvme" "ehci_pci" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = ["amdgpu"];
    };
    kernelModules = ["kvm-amd"];
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
    device = "/dev/disk/by-uuid/c48b25c2-8a07-4fff-ac1d-05ddf68765e7";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-1eff61d4-7665-4386-9376-1b2739a30f69".device = "/dev/disk/by-uuid/1eff61d4-7665-4386-9376-1b2739a30f69";

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B86E-EFF1";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  services.xserver.videoDrivers = ["amdgpu"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

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
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    kernelParams = ["pcie_aspm=force"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b043e280-e636-428a-a997-1e3d6a089c92";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b043e280-e636-428a-a997-1e3d6a089c92";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b043e280-e636-428a-a997-1e3d6a089c92";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8CBE-3A36";
    fsType = "vfat";
  };

  fileSystems."/media" = {
    device = "/dev/disk/by-uuid/24e54ecd-a805-4b56-8a89-577ecbe9e409";
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
      extraPackages32 = with pkgs; [
        intel-media-driver
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

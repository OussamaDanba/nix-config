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
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      availableKernelModules = ["amdgpu" "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["amdgpu"];
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
    kernelParams = ["amd_pstate=active"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/27148227-b756-4333-a172-88f854d965e8";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd"];
  };

  boot.initrd.luks.devices."luks-9ec9154c-fb06-4251-aee6-741cda407c43".device = "/dev/disk/by-uuid/9ec9154c-fb06-4251-aee6-741cda407c43";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D445-1955";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    keyboard.zsa.enable = true;
  };
  services.xserver.videoDrivers = ["amdgpu"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

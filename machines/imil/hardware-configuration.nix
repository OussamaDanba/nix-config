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
    device = "/dev/disk/by-uuid/1771874c-a555-420a-a807-a563511868a9";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/506B-29DA";
    fsType = "vfat";
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    keyboard.zsa.enable = true;
  };
  services.xserver.videoDrivers = ["amdgpu"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

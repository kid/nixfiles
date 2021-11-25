{ ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];

  fileSystems."./" = {
    device = "/dev/disk/by-partlabel/";
    fsType = "btrfs";
    options = [ "subvol=nixos" "compress=zstd" "autodefrag" "noatime" ];
  };

  fileSystems."./home" = {
    device = "/dev/disk/by-partlabel/";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "autodefrag" "noatime" ];
  };

  fileSystems."./boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };
}

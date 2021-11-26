{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  services.qemuGuest.enable = true;

  user = {
    name = "kid";
  };

  modules = {
    shell.enable = true;
  };
}

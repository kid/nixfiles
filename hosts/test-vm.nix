{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
    fsType = "btrfs";
  };

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  user = {
    name = "kid";
  };

  modules = {
    shell.enable = true;
  };
}

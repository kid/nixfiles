{
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
    # ./disko-config.nix
  ];

  nixfiles = {
    device.profiles = [
      "vm"
      # "desktop"
      "headless"
    ];
    virtualisation.incus.enable = true;
    storage = {
      type = "btrfs";
      mainDevice = "/dev/vda";
      impermanence.enable = true;
    };
    # FIXME: some issues with the headless profile?
    system.boot.plymouth = false;
  };

  disko.memSize = 8096;
  virtualisation.vmVariant = {
    virtualisation = {
      cores = lib.mkForce 4;
      # memorySize = 8096;
      qemu.options = [
        "-nographic"
        # "-device virtio-vga"
        # "-display gtk,zoom-to-fit=off"
      ];
    };
  };

  system.stateVersion = "25.05";

  # hardware = {
  #   graphics.enable = true;
  #   graphics.enable32Bit = true;
  # };

  services.getty.autologinUser = config.nixfiles.system.mainUser;
}

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
    ./disko-config.nix
  ];

  nixfiles = {
    device.profiles = [
      "vm"
      "desktop"
    ];
  };

  disko.memSize = 8096;
  virtualisation.vmVariant = {
    virtualisation = {
      cores = lib.mkForce 4;
      # memorySize = 8096;
      # qemu.options = [
      #   "-device virtio-vga"
      #   "-display gtk,zoom-to-fit=off"
      # ];
    };
  };

  system.stateVersion = "25.05";

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
  };

  services.getty.autologinUser = config.nixfiles.system.mainUser;
}

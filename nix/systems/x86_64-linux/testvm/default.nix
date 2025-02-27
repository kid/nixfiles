{
  lib,
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
    nix.enable = true;
  };

  # services.fwupd.enable = lib.mkForce false;

  boot = {
    # kernelParams = [ "video=Virtual-1:1920x1080@60" ];
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

  services.getty.autologinUser = "kid";
}

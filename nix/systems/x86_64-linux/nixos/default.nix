{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    ./disko-config.nix
  ];

  nixfiles.hardware.cpu.amd.enable = true;
  nixfiles.system.boot.enable = true;
  nixfiles.system.realtime.enable = true;
  nixfiles.theme.stylix.enable = true;

  system.stateVersion = "25.05";

  disko.devices.disk.main.imageSize = "10G";
}

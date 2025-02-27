{ inputs, ... }:
{
  imports =
    (with inputs.nixos-hardware.nixosModules; [
      common-pc
      common-pc-ssd
      common-cpu-amd-pstate
      common-cpu-amd-zenpower
      common-gpu-amd
    ])
    ++ [
      ./disko-config.nix
    ];

  nixfiles = {
    hardware.cpu.amd.enable = true;
    system = {
      boot.enable = true;
      realtime.enable = true;
    };
    theme.stylix.enable = true;
  };

  disko.devices.disk.main.imageSize = "10G";

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "25.05";
}

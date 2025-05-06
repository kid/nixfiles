{ inputs, ... }:
{
  imports = [
    inputs.nur.modules.nixos.default
  ];

  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];

  facter.reportPath = ./facter.json;

  nixfiles = {
    device.profiles = [
      "laptop"
      "graphical"
    ];

    storage = {
      type = "btrfs";
      mainDevice = "/dev/disk/by-id/nvme-SHPP41-2000GM_ASD9N54741120A36G_1";
      impermanence.enable = true;
    };

    # programs = {
    #   gaming.enable = true;
    # };

    # services = {
    #   printing.enable = true;
    # };

    # virtualization = {
    #   enable = true;
    #   docker.enable = true;
    #   qemu.enable = true;
    # };
  };
}

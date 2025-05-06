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
      mainDevice = "/dev/nvme0n1";
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

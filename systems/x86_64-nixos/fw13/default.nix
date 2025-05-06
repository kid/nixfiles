{
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

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu_full
    virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = ["br0"];
  };

  programs.dconf.enable = true;
}

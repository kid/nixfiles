{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu_full
    virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "br0" ];
    qemu = {
      runAsRoot = false;
      ovmf.enable = true;
    };
  };

  programs.dconf.enable = true;
}

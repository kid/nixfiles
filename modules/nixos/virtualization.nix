{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu_full
    virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
  };

  programs.dconf.enable = true;
}

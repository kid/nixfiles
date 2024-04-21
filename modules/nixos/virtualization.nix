{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu_kvm
    virt-manager
    zstd
    wget
  ];

  # virtualisation.vswitch.enable = true;

  virtualisation.libvirtd = {
    enable = false;
    allowedBridges = [ "br0" ];
    qemu = {
      runAsRoot = false;
      ovmf.enable = true;
    };
  };

  virtualisation.incus = {
    enable = true;
    socketActivation = true;
    ui.enable = true;
  };

  programs.dconf.enable = true;
}

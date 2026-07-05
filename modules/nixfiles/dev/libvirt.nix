{
  nf.dev.libvirt = {
    persist.directories = [ "/var/lib/libvirt" ];

    nixos =
      { lib, pkgs, ... }:
      {
        users.users.kid.extraGroups = lib.mkAfter [ "libvirtd" ];

        environment.systemPackages = with pkgs; [
          virt-manager
          virt-viewer
          (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
            qemu-system-x86_64 \
              -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
              "$@"
          '')
        ];

        programs.virt-manager.enable = true;

        virtualisation.libvirtd = {
          enable = true;
          qemu.swtpm.enable = true;
        };
      };
  };
}

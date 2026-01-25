{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkEnableOption;

  cfg = config.nixfiles.virtualisation;
in
{
  options.nixfiles.virtualisation = {
    enable = mkEnableOption "virtualisation";
    docker.enable = mkEnableOption "docker";
    podman.enable = mkEnableOption "podman";
    qemu.enable = mkEnableOption "qemu";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.qemu.enable {
      nixfiles.packages =
        let
          qemu-system-uefi = pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
            qemu-system-x86_64 \
              -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
              "$@"
          '';
        in
        {
          inherit qemu-system-uefi;
          inherit (pkgs) virt-manager virt-viewer;
        };

      virtualisation.libvirtd = {
        enable = true;

        qemu = {
          swtpm.enable = true;
        };
      };

      programs.virt-manager.enable = true;
    })

    (mkIf cfg.docker.enable {
      users.users.${config.nixfiles.system.mainUser}.extraGroups = [ "docker" ];
      virtualisation.docker = {
        enable = true;
      };
    })

    (mkIf cfg.podman.enable {
      nixfiles.packages = {
        inherit (pkgs) podman podman-compose;
      };

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = !cfg.docker.enable;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune = {
          enable = true;
          flags = [ "--all" ];
          dates = "weekly";
        };
      };
    })
  ]);
}

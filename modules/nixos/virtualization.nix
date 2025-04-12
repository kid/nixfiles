{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkEnableOption;

  cfg = config.nixfiles.virtualization;
in
{
  options.nixfiles.virtualization = {
    enable = mkEnableOption "virtualization";
    docker.enable = mkEnableOption "docker";
    podman.enable = mkEnableOption "podman";
    qemu.enable = mkEnableOption "qemu";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.qemu.enable {
      nixfiles.packages = {
        inherit (pkgs) virt-manager virt-viewer;
      };

      virtualisation.libvirtd = {
        enable = true;

        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = with pkgs; [ OVMFFull.fd ];
          };
        };
      };
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

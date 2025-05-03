{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;
  cfg = config.nixfiles.virtualisation.incus;
in
{
  options.nixfiles.virtualisation.incus = {
    enable = mkEnableOption "Incus";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      virtualisation = {
        incus = {
          enable = true;
          # defaults to incus-lts
          package = pkgs.incus;
          ui.enable = true;
          preseed = {
            config."core.https_address" = "[::]:8443";
            networks = [ ];
            profiles = [
              {
                name = "default";
                devices.root = {
                  path = "/";
                  pool = "default";
                  type = "disk";
                };
              }
            ];
            storage_pools = [
              {
                name = "default";
                driver = config.nixfiles.storage.type;
                config = {
                  source = "/var/lib/incus/storage-pools/default";
                };
              }
            ];
          };
        };
        vswitch.enable = true;
      };

      nixfiles.packages = { inherit (pkgs) incus ovn; };

      networking = {
        nftables.enable = true;
        firewall.allowedTCPPorts = [ 8443 ];
      };

      users.users.${config.nixfiles.system.mainUser}.extraGroups = [ "incus-admin" ];
    }

    (mkIf config.nixfiles.storage.impermanence.enable {
      nixfiles.storage.impermanence.persistence."/persist/incus".directories = [
        "/var/lib/incus"
      ];
    })
  ]);
}

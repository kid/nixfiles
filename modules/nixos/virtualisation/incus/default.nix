{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.virtualisation.incus;
in
{
  options.nixfiles.virtualisation.incus = {
    enable = mkEnableOption "Incus";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      incus = {
        enable = true;
        # defaults to incus-lts
        package = pkgs.incus;
        ui.enable = true;
        preseed = {
          config."core.https_address" = "[::]:8443";
          networks = [ ];
          profiles = [ ];
          storage_pools = [
            {
              config = {
                source = "/var/lib/incus/storage-pools/default";
              };
              driver = "dir";
              name = "default";
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
  };
}

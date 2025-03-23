{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_: {
  virtualisation.incus = {
    enable = true;
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

  environment.systemPackages = with pkgs; [ incus ];

  networking = {
    nftables.enable = true;
    firewall.allowedTCPPorts = [ 8443 ];
  };

  users.users.${config.${namespace}.user.name}.extraGroups = [ "incus-admin" ];
})

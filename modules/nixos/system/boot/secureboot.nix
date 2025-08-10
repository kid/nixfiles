{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkForce;

  cfg = config.nixfiles.system.boot;
  storageCfg = config.nixfiles.storage;
in
{

  config = mkIf cfg.secureBoot {
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    environment.systemPackages = builtins.attrValues {
      # For debugging and troubleshooting secure boot
      inherit (pkgs) sbctl;
    };

    # Lanzaboote replaces the systemd-boot module
    boot.loader.systemd-boot.enable = mkForce false;

    nixfiles.storage.impermanence.persistence = mkIf storageCfg.impermanence.enable {
      "/persist/system".directories = [ "/var/lib/sbctl" ];
    };
  };
}

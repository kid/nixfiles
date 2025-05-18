{
  config,
  options,
  lib,
  ...
}:
with lib;
let
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.nixfiles.storage.impermanence;
in
{
  options.nixfiles.storage.impermanence = {
    enable = mkEnableOption "impermanence";

    persistence = mkOption {
      inherit (options.environment.persistence) default description type;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nixfiles.storage.impermanence.persistence = {
        "/persist/system" = {
          hideMounts = true;

          files = [
            "/etc/machine-id"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
          ];

          directories = [
            "/var/lib/bluetooth"
            "/var/lib/fwupd"
            "/var/lib/nixos"
            "/var/lib/sddm"
            "/var/log"
          ];
        };
      };
    }

    {
      environment.persistence = cfg.persistence;
    }

    {
      nixfiles.storage.extraSubVolumes = builtins.attrNames cfg.persistence;
    }

    {
      fileSystems = lib.mapAttrs' (
        mountPoint: _:
        lib.nameValuePair mountPoint {
          neededForBoot = lib.mkForce true;
        }
      ) cfg.persistence;
    }

    {

      virtualisation.vmVariantWithDisko.virtualisation.fileSystems = lib.mapAttrs' (
        mountPoint: _:
        lib.nameValuePair mountPoint {
          neededForBoot = lib.mkForce true;
        }
      ) cfg.persistence;
    }
  ]);
}

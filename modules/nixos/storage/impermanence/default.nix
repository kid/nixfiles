{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixfiles.storage.impermanence;
in
{
  options.nixfiles.storage.impermanence.enable = mkEnableOption "btrfs";

  config = mkIf cfg.enable {
    environment.persistence."/persist/system" = {
      hideMounts = true;

      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];

      directories = [
        "/var/lib/bluetoth"
        "/var/lib/nixos"
      ];
    };
  };
}

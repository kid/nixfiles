{
  self,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf types;
  inherit (self.lib) mkOpt;
  cfg = config.nixfiles.security.sops;
in
{
  options.nixfiles.security.sops = {
    enable = mkEnableOption "sops";
    defaultSopsFile = mkOpt types.path null "Default sops file.";
    sshKeyPaths = mkOpt (types.listOf types.path) [
      "/etc/ssh/ssh_host_ed25519_key"
    ] "SSH key paths to use.";
  };

  config = mkIf cfg.enable {
    sops = {
      inherit (cfg) defaultSopsFile;

      age = {
        inherit (cfg) sshKeyPaths;

        # keyFile = "${config.users.users.${config.nixfiles.user.name}.home}/.config/sops/age/keys.txt";
      };
    };
  };
}

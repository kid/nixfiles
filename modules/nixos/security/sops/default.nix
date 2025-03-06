{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.types) listOf path;
  inherit (lib.${namespace}) mkModule mkOpt;
in
mkModule ./. false config
  {
    defaultSopsFile = mkOpt path null "Default sops file.";
    sshKeyPaths = mkOpt (listOf path) [
      "/etc/ssh/ssh_host_ed25519_key"
    ] "SSH key paths to use.";
  }
  (cfg: {
    sops = {
      inherit (cfg) defaultSopsFile;

      age = {
        inherit (cfg) sshKeyPaths;

        # keyFile = "${config.users.users.${config.${namespace}.user.name}.home}/.config/sops/age/keys.txt";
      };
    };
  })

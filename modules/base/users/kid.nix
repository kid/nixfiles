{
  lib,
  config,
  ...
}:
let
  inherit (lib) elem mkIf;
in
{
  config = mkIf (elem "kid" config.nixfiles.system.users) {
    users.users.kid.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx9vvChkupOOoETU4Y1hv+469DFV0TdEVdONeqfXn04 kid@nixos"
    ];
  };
}

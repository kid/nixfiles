{
  lib,
  localLib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (localLib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "server" ]) {
    time.timeZone = mkForce "UTC";

    nixfiles = {
      system = {
        activation.diff.enable = true;
        boot = {
          enable = true;
          silent = false;
          plymouth = false;
        };
      };
    };
  };
}

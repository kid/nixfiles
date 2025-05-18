{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (self.lib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "server" ]) {
    time.timeZone = mkForce "UTC";

    nixfiles = {
      system.activation.diff.enable = true;
      system = {
        boot = {
          enable = true;
          silent = false;
          plymouth = false;
        };
      };
      hardware = {
        firmware.enable = true;
      };
    };
  };
}

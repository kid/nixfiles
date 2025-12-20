{
  lib,
  localLib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (localLib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "laptop" ]) {
    nixfiles = {
      # Need to login once for fingerprint to work
      security.autoLogin = false;
      system = {
        boot = {
          enable = true;
          silent = true;
          plymouth = true;
          rememberLast = true;
        };
        realtime.enable = true;
      };
      hardware = {
        power.enable = true;
        audio.enable = true;
      };
      storage.impermanence = {
        enable = true;
      };
    };

    time.timeZone = "Europe/Brussels";
  };
}

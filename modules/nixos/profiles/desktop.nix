{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "desktop" ]) {
    nixfiles = {
      security.autoLogin = true;
      system = {
        boot = {
          enable = true;
          silent = true;
          plymouth = true;
          rememberLast = true;
        };
        realtime.enable = false;
      };
      hardware = {
        power.usbPowerControl = "on";
        audio.enable = true;
        # bluetooth.enable = true;
      };
    };

    time.timeZone = "Europe/Brussels";
  };
}

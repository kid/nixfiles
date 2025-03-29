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
        power.usbPowerControl = "on";
        audio.enable = true;
        # bluetooth.enable = true;
      };
    };

    # TODO: move this to its own module, maybe back to home-manager?
    programs.nixvim.enable = true;
    programs.nixvim.defaultEditor = true;
  };
}

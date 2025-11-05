{
  self,
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib.programs) mkProgram;
  inherit (self.lib.validators) hasProfile;

  cfg = config.nixfiles.programs.gui.niri;
in
{
  options.nixfiles.programs.gui = {
    niri = mkProgram pkgs "niri" {
      enable.default = config.nixfiles.programs.gui.enable && (hasProfile osConfig [ "laptop" ]);
    };
  };

  config.programs.niri.settings = mkIf cfg.enable {
    binds = with config.lib.niri.actions; {
      "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "+5%";
      "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "-5%";

      "Mod+K".action = set-column-width "+10%";
      "Mod+J".action = set-column-width "-10%";
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+Shift+E".action = quit;
    };
  };
}

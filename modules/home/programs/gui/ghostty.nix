{
  localLib,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (localLib.programs) mkProgram;

  cfg = config.nixfiles.programs.gui.ghostty;
in
{
  options.nixfiles.programs.gui = {
    ghostty = mkProgram pkgs "ghostty" {
      enable.default = config.nixfiles.programs.gui.enable;
    };
  };

  config.programs.ghostty = mkIf cfg.enable {
    enable = true;

    settings = {
      keybind = [
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:bottom"
        "ctrl+shift+k=goto_split:top"
        "ctrl+shift+l=goto_split:right"
      ];
    };
  };
}

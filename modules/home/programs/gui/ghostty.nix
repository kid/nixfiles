{
  self,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib.programs) mkProgram;

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
  };
}

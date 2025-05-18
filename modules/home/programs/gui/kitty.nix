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

  cfg = config.nixfiles.programs.gui.kitty;
in
{
  options.nixfiles.programs.gui = {
    kitty = mkProgram pkgs "kitty" {
      enable.default = config.nixfiles.programs.gui.enable;
    };
  };

  config.programs.kitty = mkIf cfg.enable {
    enable = true;
  };
}

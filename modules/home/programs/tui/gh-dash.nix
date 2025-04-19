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

  cfg = config.nixfiles.programs.tui.ghostty;
in
{
  options.nixfiles.programs.tui = {
    ghostty = mkProgram pkgs "gh-dash" {
      enable.default = config.nixfiles.programs.tui.enable;
    };
  };

  config.programs.gh-dash = mkIf cfg.enable {
    enable = true;
  };
}

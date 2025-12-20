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

  cfg = config.nixfiles.programs.tui.gh-dash;
in
{
  options.nixfiles.programs.tui = {
    gh-dash = mkProgram pkgs "gh-dash" {
      enable.default = config.nixfiles.programs.tui.enable;
    };
  };

  config.programs.gh-dash = mkIf cfg.enable {
    enable = true;
  };
}

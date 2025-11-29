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

  cfg = config.nixfiles.programs.tui.zellij;
in
{
  options.nixfiles.programs.tui = {
    zellij = mkProgram pkgs "zellij" {
      enable.default = config.nixfiles.programs.tui.enable;
    };
  };

  config.programs.zellij = mkIf cfg.enable {
    enable = true;
  };
}

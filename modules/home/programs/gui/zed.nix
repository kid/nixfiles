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

  cfg = config.nixfiles.programs.gui.zed-editor;
in
{
  options.nixfiles.programs.gui = {
    zed-editor = mkProgram pkgs "zed" {
      enable.default = config.nixfiles.programs.gui.enable;
    };
  };

  config.programs.zed-editor = mkIf cfg.enable {
    enable = true;
    userSettings = {
      vim_mode = true;
    };
  };
}

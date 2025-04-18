{
  self,
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib.modules) mkOptionDefault;
  inherit (lib.options) mkEnableOption;
  inherit (self.lib.validators) hasProfile;

  cfg = config.nixfiles.programs;
in
{
  options.nixfiles.programs = {
    cli = {
      enable = mkEnableOption "CLI programs" // {
        default = true;
      };
    };

    tui.enable = mkEnableOption "TUI programs" // {
      default = cfg.cli.enable;
    };

    gui.enable = mkEnableOption "GUI programs" // {
      inherit (lib.modules) mkOptionDefault;
      enable = mkOptionDefault hasProfile osConfig [ "graphical" ];
    };
  };
}

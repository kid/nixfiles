{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.nixfiles.programs.gaming;
in
{
  config.programs.gamescope = mkIf cfg.enable {
    enable = true;
    # capSysNice = true;
  };
}

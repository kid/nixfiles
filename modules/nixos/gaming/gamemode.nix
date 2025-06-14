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
  config.programs.gamemode = mkIf cfg.enable {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
    };
  };
}

{
  lib,
  config,
  pkgs,
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
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'";
        end = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'";
      };
    };
  };
}

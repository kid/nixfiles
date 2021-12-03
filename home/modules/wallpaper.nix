{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.wallpaper;
in
{
  options.services.wallpaper.enable = mkEnableOption "Wallaper";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.feh ];
    systemd.user.services.wallpaper = {
      Unit = {
        Description = "Wallpaper Service";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = ["graphical-session.target"]; };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --randomize --no-fehbg --bg-fill ${../wallpapers}";
      };
    };
  };
}

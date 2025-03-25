# TODO: replace with https://github.com/musnix/musnix and/or https://github.com/fps/rtnix
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixfiles.system.realtime;
in
{
  # port of https://gitlab.archlinux.org/archlinux/packaging/packages/realtime-privileges
  # see https://wiki.archlinux.org/title/Realtime_process_management
  # tldr: realtime processes have higher priority than normal processes
  # and that's a good thing

  options.nixfiles.system.realtime = {
    enable = mkEnableOption "Realtime";
  };

  config = mkIf cfg.enable {
    users = {
      # TODO: load this from a config
      users.kid.extraGroups = [ "realtime" ];
      groups.realtime = { };
    };

    services.udev.extraRules = ''
      KERNEL=="cpu_dma_latency", GROUP="realtime"
    '';

    security.pam.loginLimits = [
      {
        domain = "@realtime";
        type = "-";
        item = "rtprio";
        value = 98;
      }
      {
        domain = "@realtime";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@realtime";
        type = "-";
        item = "nice";
        value = -11;
      }
    ];
  };
}

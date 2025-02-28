# TODO: replace with https://github.com/musnix/musnix and/or https://github.com/fps/rtnix
{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_: {
  # port of https://gitlab.archlinux.org/archlinux/packaging/packages/realtime-privileges
  # see https://wiki.archlinux.org/title/Realtime_process_management
  # tldr: realtime processes have higher priority than normal processes
  # and that's a good thing
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
})

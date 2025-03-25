{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.nixfiles.suites.desktop;
in
{
  options.nixfiles.suites.desktop.enable = mkEnableOption "desktop";

  config = mkIf cfg.enable {
    nixfiles = {
      system = {
        boot = {
          enable = mkDefault true;
          silent = mkDefault true;
          plymouth = mkDefault true;
          rememberLast = mkDefault true;
        };
        realtime.enable = mkDefault true;
      };
      hardware.audio.enable = mkDefault true;
    };
  };
}

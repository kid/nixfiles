{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.suites.server;
in
{
  options.nixfiles.suites.server.enable = mkEnableOption "server";

  config = mkIf cfg.enable {
    nixfiles = {
      system = {
        boot = {
          enable = true;
          silent = false;
          plymouth = false;
        };
      };
      hardware = {
        firmware.enable = true;
        power = {
          governor = "powersave";
          energy_performance_preference = "balance_power";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      ghostty.terminfo
      kitty.terminfo
      wezterm.terminfo
    ];
  };
}

{
  lib,
  self,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (self.lib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "server" ]) {
    time.timeZone = mkForce "UTC";

    nixfiles = {
      system.activation.diff.enable = true;
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

    # TODO: find a better place for this
    environment.systemPackages = with pkgs; [
      ghostty.terminfo
      kitty.terminfo
      wezterm.terminfo
    ];
  };
}

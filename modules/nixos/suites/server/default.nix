{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_cfg: {
  ${namespace} = {
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
})

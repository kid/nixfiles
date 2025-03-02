{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled mkModule;
in
mkModule ./. false config { } (_cfg: {
  ${namespace} = {
    suites = {
      common = enabled;
    };
    hardware = {
      firmware.enable = true;
      power = {
        governor = "powersave";
        energy_performance_preference = "balance_power";
      };
    };
    system = {
      boot = {
        enable = true;
        silent = false;
        plymouth = false;
      };
    };
  };
})

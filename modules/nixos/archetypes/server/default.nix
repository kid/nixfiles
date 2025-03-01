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
    hardware.power.governor = "powersave";
    system = {
      boot = {
        enable = true;
        silent = false;
        plymouth = false;
      };
    };
  };

})

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
    system = {
      boot = {
        enable = true;
        silent = true;
        plymouth = true;
      };
      realtime = enabled;
    };
  };
})

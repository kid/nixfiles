{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_cfg: {
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
})

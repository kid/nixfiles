{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_cfg: {
  environment.systemPackages =
    with pkgs;
    [
      powertop
    ]
    ++ (with config.boot.kernelPackages; [ cpupower ]);

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
})

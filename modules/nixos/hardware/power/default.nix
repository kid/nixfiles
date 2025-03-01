{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.${namespace}) mkModule mkOpt;
in
mkModule ./. false config
  {
    governor = mkOpt types.str "performance" "Governor used to regulate CPU frequency";
  }
  (cfg: {
    environment.systemPackages =
      with pkgs;
      [
        powertop
      ]
      ++ (with config.boot.kernelPackages; [ cpupower ]);

    powerManagement = {
      enable = true;
      cpuFreqGovernor = cfg.governor;
      powertop.enable = true;
    };
  })

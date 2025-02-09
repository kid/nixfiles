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
mkModule ./. config { } (_: {
  boot = {
    kernelModules = [
      "kvm-amd"
      "msr"
    ];
  };

  environment.systemPackages = [ pkgs.amdctl ];

  hardware.cpu.amd.updateMicrocode = true;
})

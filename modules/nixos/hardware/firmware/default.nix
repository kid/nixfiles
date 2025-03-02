{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
  inherit (config.facter) report reportPath;
  virtualized = (report.virtualisation or null) != "none";
in
mkModule ./. false config { } (_cfg: {
  services = {
    fwupd = {
      enable = !virtualized;
      daemonSettings.EspUpdateLevel = config.boot.loader.efi.efiSysMountPoint;
    };

    ucodenix = {
      enable = !virtualized;
      cpuModelId = reportPath;
    };
  };

  # NOTE: force disable when running via build-vm
  virtualisation.vmVariant = {
    services = {
      fwupd.enable = false;
      ucodenix.enable = false;
    };
  };
})

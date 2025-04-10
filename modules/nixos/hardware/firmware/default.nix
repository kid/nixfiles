{
  config,
  lib,
  ...
}:
with lib;
let
  inherit (config.facter) report reportPath;
  cfg = config.nixfiles.hardware.firmware;
  virtualized = (report.virtualisation or null) != "none";
in

{
  options.nixfiles.hardware.firmware.enable = mkEnableOption "firmware";

  config = mkIf cfg.enable {
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
  };
}

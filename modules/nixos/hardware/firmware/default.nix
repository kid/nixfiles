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
  isAMD = (builtins.elemAt report.hardware.cpu 0).vendor_name == "AuthenticAMD";
in

{
  options.nixfiles.hardware.firmware.enable = mkEnableOption "firmware";

  config = mkIf cfg.enable {
    # Disable microcode checksum verification for ucodenix to work
    boot.kernelParams = mkIf (!virtualized && isAMD) [ "microcode.amd_sha_check=off" ];

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

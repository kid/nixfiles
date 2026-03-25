{
  localLib,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    types
    ;
  inherit (localLib) mkOpt;
  cfg = config.nixfiles.hardware.power;
in
{
  options.nixfiles.hardware.power = {
    enable = mkEnableOption "Power";
    usbPowerControl = mkOpt (types.enum [
      "auto"
      "on"
      "off"
    ]) "auto" "Default mode for USB power/control";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        powertop
        s-tui
      ]
      ++ (with config.boot.kernelPackages; [ cpupower ]);

    boot.kernel.sysctl = {
      # NOTE: NMI watchdog can cause increase in power usage
      "kernel.nmi_watchdog" = 0;
      # NOTE: Increase virtual memory dirty writeback to help aggregate disk I/O
      # TODO: set commit=60 on supported filesystems
      "vm.dirty_writeback_centisecs" = 1500;
    };

    powerManagement.scsiLinkPolicy = "med_power_with_dipm";

    services = {
      power-profiles-daemon.enable = true;

      udev.extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="${cfg.usbPowerControl}"
        ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
        SUBSYSTEM=="ata_port", KERNEL=="ata*", ATTR{device/power/control}="auto"
      '';
    };
  };
}

{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkForce types;
  inherit (lib.${namespace}) mkModule mkOpt;
in
mkModule ./. false config
  {
    governor = mkOpt types.str "performance" "Governor used to regulate CPU frequency";
    energy_performance_preference =
      mkOpt types.str "balance_performance"
        "Energy performance preference";
  }
  (cfg: {
    environment.systemPackages =
      with pkgs;
      [
        powertop
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
      auto-cpufreq = {
        enable = true;
        settings.charger = {
          inherit (cfg) governor energy_performance_preference;
          turbo = "auto";
        };
      };

      thermald.enable = true;

      # NOTE:This is enabled by plasma and conflict with auto-cpufreq
      power-profiles-daemon.enable = mkForce false;

      udev.extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="pci|usb", TEST=="power/control", ATTR{power/control}="auto"
        ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
        SUBSYSTEM=="ata_port", KERNEL=="ata*", ATTR{device/power/control}="auto"
      '';
    };
  })

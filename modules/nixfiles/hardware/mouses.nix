{
  nf.hardware.logitech = {
    nixos = { pkgs, ... }: {
      services.ratbagd.enable = true;

      environment.systemPackages = with pkgs; [
        piper
      ];
    };
  };

  nf.hardware.razer = {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.hardware.openrazer;
        toPyBool = b: if b then "True" else "False";

        # The daemon keys per-device settings by serial. It sometimes reads an
        # empty serial while the mouse wakes and invents UNKNOWN_<vid><pid>_<n>
        # instead, so list every identity it can resolve to.
        serials = [ "PM2552H33301086" ] ++ map (n: "UNKNOWN_153200CD_000${toString n}") (lib.range 0 3);

        # Same keys as the NixOS module's razer.conf, plus Device sections.
        razerConf = pkgs.writeText "razer.conf" ''
          [General]
          verbose_logging = ${toPyBool cfg.verboseLogging}

          [Startup]
          sync_effects_enabled = ${toPyBool cfg.syncEffectsEnabled}
          devices_off_on_screensaver = ${toPyBool cfg.devicesOffOnScreensaver}
          battery_notifier = ${toPyBool cfg.batteryNotifier.enable}
          battery_notifier_freq = ${toString cfg.batteryNotifier.frequency}
          battery_notifier_percent = ${toString cfg.batteryNotifier.percentage}

          [Statistics]
          key_statistics = ${toPyBool cfg.keyStatistics}
          ${lib.concatMapStrings (s: ''

            [Device:${s}]
            driver_mode = True
          '') serials}
        '';
      in
      {
        hardware.openrazer = {
          enable = true;
        };

        environment.systemPackages = with pkgs; [
          polychromatic
          razer-cli
        ];

        # Basilisk V3 Pro: force driver mode so the clutch/sniper button
        # (BTN_TASK) is forwarded as an input event instead of being
        # handled by firmware, so input-remapper (or anything else) can
        # see it. This also stops the firmware handling DPI up/down and
        # tilt-wheel scroll.
        #
        # The daemon applies driver_mode from its config at startup and again
        # on resume, because suspend resets the mouse. The NixOS module
        # hardcodes its own razer.conf without Device sections, so replace
        # the unit's ExecStart to use ours.
        systemd.user.services.openrazer-daemon.serviceConfig.ExecStart =
          lib.mkForce "${cfg.packages.daemon}/bin/openrazer-daemon --config ${razerConf} --foreground";
      };

    provides.to-users = { user, ... }: {
      nixos = {
        hardware.openrazer.users = [ user.name ];
      };
    };
  };
}

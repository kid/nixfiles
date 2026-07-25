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
    nixos = { pkgs, ... }: {
      hardware.openrazer = {
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        polychromatic
        razer-cli
      ];
    };

    provides.to-users = { user, ... }: {
      nixos = {
        hardware.openrazer.users = [ user.name ];
      };

      homeManager =
        { pkgs, ... }:
        {
          # Basilisk V3 Pro: force driver mode so the clutch/sniper button
          # (BTN_TASK) is forwarded as an input event instead of being
          # handled by firmware, so input-remapper (or anything else) can
          # see it. This also stops the firmware handling DPI up/down and
          # tilt-wheel scroll.
          #
          # The NixOS hardware.openrazer module generates its own
          # razer.conf from Nix options and always launches the daemon
          # with that file via `--config`, ignoring
          # `~/.config/openrazer/razer.conf` entirely and with no
          # per-device section support - so driver mode can't be declared
          # through the daemon's config. Setting it via its D-Bus API on
          # every daemon start is the only way that actually persists.
          #
          # The device serial OpenRazer reports isn't stable across
          # boots/reconnects (it sometimes falls back to a generated
          # "UNKNOWN_..." placeholder instead of the real hardware
          # serial), so the serial is looked up at runtime instead of
          # hardcoded.
          systemd.user.services.razer-driver-mode = {
            Unit = {
              Description = "Force Basilisk V3 Pro into OpenRazer driver mode";
              After = [ "openrazer-daemon.service" ];
              PartOf = [ "openrazer-daemon.service" ];
            };
            Service = {
              Type = "oneshot";
              # Default systemd start timeout (90s) is shorter than the
              # retry budget below (up to ~300s), so it would otherwise
              # get killed mid-retry.
              TimeoutStartSec = "330s";
              # Racing the daemon at boot: the unit is "started" (bus name
              # acquired) well before the per-device dbus object finishes
              # registering - empirically this can take much longer than
              # a few seconds, so retry with real patience rather than
              # bailing early and relying on a manual restart.
              ExecStart = pkgs.writeShellScript "razer-driver-mode" ''
                for i in $(seq 1 150); do
                  devices=$(${pkgs.dbus}/bin/dbus-send --session --dest=org.razer --type=method_call \
                    --print-reply /org/razer razer.devices.getDevices 2>&1)
                  serial=$(echo "$devices" | ${pkgs.gnugrep}/bin/grep -oP '(?<=string ")[^"]+' | head -n1)
                  ${pkgs.dbus}/bin/dbus-send --session --dest=org.razer --type=method_call \
                    --print-reply "/org/razer/device/$serial" razer.device.misc.setDeviceMode byte:3 byte:0 2>&1
                  getmode=$(${pkgs.dbus}/bin/dbus-send --session --dest=org.razer --type=method_call \
                    --print-reply "/org/razer/device/$serial" razer.device.misc.getDeviceMode 2>&1)
                  # setDeviceMode always reports success even when the kernel
                  # driver silently ignores the write (e.g. the mouse hasn't
                  # fully woken/settled yet), so getDeviceMode's readback is
                  # the only trustworthy success signal.
                  if [ -n "$serial" ] && echo "$getmode" | ${pkgs.gnugrep}/bin/grep -q '"3:0"'; then
                    exit 0
                  fi
                  sleep 2
                done
                exit 1
              '';
            };
            Install.WantedBy = [ "openrazer-daemon.service" ];
          };
        };
    };
  };
}

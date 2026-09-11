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

      # Basilisk V3 Pro: force driver mode so the clutch/sniper button
      # (BTN_TASK) is forwarded as an input event instead of being
      # handled by firmware, so input-remapper (or anything else) can
      # see it. This also stops the firmware handling DPI up/down and
      # tilt-wheel scroll.
      #
      # This used to go through the daemon's D-Bus API, retried for up
      # to 300s because the per-device D-Bus object races the daemon's
      # own startup and often wasn't ready in time. The kernel driver
      # exposes device_mode as a raw sysfs attribute directly
      # (razermouse_driver.c: razer_attr_write_device_mode reads the
      # first two bytes of the write as mode/param, no ASCII, no
      # daemon, no D-Bus) - so a udev rule that fires on the driver's
      # own "bind" event sets it the moment the attribute exists,
      # before openrazer-daemon even starts.
      services.udev.extraRules = ''
        ACTION=="bind", SUBSYSTEM=="hid", DRIVER=="razermouse", RUN+="${pkgs.writeShellScript "razer-driver-mode" ''
          mode_file="/sys$DEVPATH/device_mode"
          [ -e "$mode_file" ] && printf '\003\000' > "$mode_file"
        ''}"
      '';
    };

    provides.to-users = { user, ... }: {
      nixos = {
        hardware.openrazer.users = [ user.name ];
      };
    };
  };
}

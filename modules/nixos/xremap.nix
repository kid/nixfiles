{
  config,
  lib,
  pkgs,
  ...
}:
{
  # hardware.uinput.enable = true;
  # users.groups.uinput.members = [ config.user.name ];

  services.xremap = {
    serviceMode = "user";
    userName = config.user.name;
    withKDE = true;
    # debug = true;
    watch = true;
    config.keymap = [
      {
        # name = "main";
        # device.only = [
        #   "/dev/input/by-id/usb-Keebio_Quefrency_0-event-if01"
        #   "/dev/input/by-id/usb-Keebio_Quefrency_0-event-kbd"
        # ];
        remap = {
          SUPER-B = {
            launch = [ "${lib.getExe pkgs.firefox}" ];
          };
          SUPER-SHIFT-B = {
            launch = [
              "${lib.getExe pkgs.firefox}"
              "--private-window"
            ];
          };
          SUPER-T = {
            launch = [ "${lib.getExe pkgs.wezterm}" ];
          };
          SUPER-P = {
            launch = [ "${pkgs.kdePackages.plasma-workspace}/bin/krunner" ];
          };
        };
      }
    ];
  };
}

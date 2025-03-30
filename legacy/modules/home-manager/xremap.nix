{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: wrap this in our own program
  services.xremap = {
    # serviceMode = "user";
    withKDE = true;
    # debug = true;
    watch = true;
    # deviceName = "/dev/input/by-id/usb-Keebio_Quefrency_0-event-kbd";
    config.keymap = [
      {
        # name = "main";
        # device.only = [
        #   "/dev/input/by-id/usb-Keebio_Quefrency_0-event-if01"
        #   "/dev/input/by-id/usb-Keebio_Quefrency_0-event-kbd"
        # ];
        remap = {
          SUPER-B = {
            # launch = [ "${lib.getExe pkgs.firefox}" ];
            launch = [ "${lib.getExe config.programs.firefox.finalPackage}" ];
          };
          SUPER-SHIFT-B = {
            launch = [
              "${lib.getExe config.programs.firefox.finalPackage}"
              "--private-window"
            ];
          };
          SUPER-T = {
            launch = [ "${lib.getExe config.programs.wezterm.package}" ];
          };
          SUPER-P = {
            launch = [ "${pkgs.kdePackages.plasma-workspace}/bin/krunner" ];
          };
        };
      }
    ];
  };
}

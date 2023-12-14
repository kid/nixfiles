{
  services.kanshi = {
    enable = false;
    # systemdTarget = "graphical-session.target";
    systemdTarget = "";
    profiles = {
      default = {
        outputs =
          [
            {
              criteria = "HDMI-A-1";
              status = "disable";
            }
            {
              criteria = "DP-2";
              mode = "2560x1440@60Hz";
            }
          ];
      };
    };
  };
}

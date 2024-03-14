{
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    # systemdTarget = "";
    profiles = {
      default = {
        outputs = [
          {
            criteria = "HDMI-A-1";
            mode = "3840x2160@60Hz";
            adaptiveSync = true;
          }
        ];
      };
      displayport = {
        outputs = [
          {
            criteria = "HDMI-A-1";
            status = "disable";
          }
          {
            criteria = "DP-3";
            mode = "3840x2160@138Hz";
            adaptiveSync = true;
          }
        ];
      };
    };
  };
}

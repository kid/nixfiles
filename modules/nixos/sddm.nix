{ config, ... }:
{
  services.xserver = {
    enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.user.name;
      };
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };

  services.desktopManager.plasma6.enable = true;
}

{ config, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;

  services.getty.autologinUser = config.user.name;
}

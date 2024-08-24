{ config, pkgs, ... }:
{
  services = {
    xserver.enable = true;

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

    desktopManager.plasma6.enable = true;
  };

  security.pam.services.sddm.kwallet.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard-rs
    kdePackages.neochat
  ];
}

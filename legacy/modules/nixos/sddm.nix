{ config, pkgs, ... }:
{
  services = {
    xserver.enable = true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = config.nixfiles.system.mainUser;
      };
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    desktopManager.plasma6.enable = true;
    # desktopManager.cosmic.enable = true;
  };

  security.pam.services.sddm.kwallet.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard-rs
    # FIXME: dependency marked as insecured
    # kdePackages.neochat
  ];
}

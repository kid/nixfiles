{ config, pkgs, ... }: {
  services = {
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

  environment.systemPackages = with pkgs; [ wl-clipboard-rs ];
}

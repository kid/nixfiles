{ config, ... }:
{
  services.getty.autologinUser = config.user.name;

  # services.xserver.enable = true;
  # services.xserver.displayManager.startx.enable = true;

  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.startx.enable = true;
    # desktopManager = {
    #   default = "xsession";
    #   session = [{
    #     name = "xsession";
    #     manager = "desktop";
    #     start = "exec $HOME/.xsession";
    #   }];
    # };
  };

  # recommended for pipewire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # Why do we need this again?
  programs.dconf.enable = true;
}

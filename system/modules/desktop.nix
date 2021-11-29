{ config, pkgs, ... }:
{
  services.getty.autologinUser = config.user.name;

  # services.xserver.enable = true;
  # services.xserver.displayManager.startx.enable = true;

  services.upower.enable = true;

  services.xserver = {
    enable = true;
    libinput.enable = true;

    displayManager.startx.enable = true;

    # displayManager.lightdm.enable = true;
    # displayManager.defaultSession = "none+xmonad";
    #
    # updateDbusEnvironment = true;
    #
    # windowManager = {
    #   session = [
    #     {
    #       name = "xmonad";
    #       start = "exec ${pkgs.haskellPackages.xmonad-kid}/bin/xmonad-kid";
    #     }
    #   ];
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

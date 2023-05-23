{ config, ... }:
{
  services.getty.autologinUser = config.user.name;

  services.upower.enable = true;

  services.xserver = {
    enable = true;
    libinput.enable = true;

    displayManager.startx.enable = true;
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

  programs._1password-gui = {
    enable = true;
  };

  powerManagement = {
    enable = true;
    # cpuFreqGovernor = "schedutil";
    powertop.enable = false;
  };

  hardware.nvidia.powerManagement = {
    enable = true;
  };
}

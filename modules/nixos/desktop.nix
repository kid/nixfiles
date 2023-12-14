{ config, ... }:
{
  services.getty.autologinUser = config.user.name;

  services.upower.enable = true;

  security.polkit.enable = true;

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
    polkitPolicyOwners = [ config.user.name ];
  };

  powerManagement = {
    enable = true;
    # cpuFreqGovernor = "schedutil";
    powertop.enable = false;
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
}

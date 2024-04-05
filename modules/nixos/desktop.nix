{ config, pkgs, ... }:
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
    # Should be the default?
    wireplumber.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
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

  services.blueman.enable = true;

  # environment.etc = {
  #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #     bluez_monitor.properties = {
  #     	["bluez5.enable-sbc-xq"] = true,
  #     	["bluez5.enable-msbc"] = true,
  #     	["bluez5.enable-hw-volume"] = true,
  #     	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  #     }
  #   '';
  # };

  environment.systemPackages = with pkgs; [
    pavucontrol
    xboxdrv
    # vulkan-tools
    # vulkan-loader
    # vulkan-validation-layers
    # vulkan-hdr-layer
  ];

  programs.nix-ld.enable = true;
}

{ config, pkgs, ... }:
{
  services = {
    getty.autologinUser = config.user.name;

    upower.enable = true;

    pipewire = {
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
          default = {
            clock = {
              rate = 48000;
              quantum = 32;
              min-quantum = 32;
              max-quantum = 32;
            };
          };
        };
      };
    };

    blueman.enable = true;

    locate.enable = true;
  };

  security.polkit.enable = true;

  # recommended for pipewire
  security.rtkit.enable = true;

  programs = {

    # Why do we need this again?
    dconf.enable = true;

    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ config.user.name ];
    };

    nix-ld = {
      enable = true;
    };
  };

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

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
    # vulkan-tools
    # vulkan-loader
    # vulkan-validation-layers
    # vulkan-hdr-layer
  ];

  # NOTE: https://github.com/nix-community/home-manager/issues/4199#issuecomment-2226810699
  system.userActivationScripts.removeConflictingFiles.text = ''
    rm -f /home/${config.user.name}/.gtkrc-2.0.backup
  '';
}

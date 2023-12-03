{ lib, pkgs, ... }:
let
  modifier = "Mod4";
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      inherit modifier;
      terminal = "kitty";

      output = {
        "HDMI-A-1" = {
          power = "off";
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+p" = "exec rofi -show";
        "${modifier}+b" = "exec chromium";
      };
    };
  };

  home.packages = with pkgs; [
    waybar
  ];

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}

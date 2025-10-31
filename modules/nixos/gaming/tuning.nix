{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.nixfiles.programs.gaming;
in
{
  config = mkIf cfg.enable {
    programs.wine = {
      enable = true;
      ntsync = true;
    };

    environment.sessionVariables = {
      MESA_VK_WSI_PRESENT_MODE = "immediate";
      KWIN_DRM_NO_AMS = "1";
      PROTON_ENABLE_WAYLAND = "1";
      PROTON_ENABLE_HDR = "1";
      PROTON_USE_NTSYNC = 1;
      SDL_VIDEODRIVER = "wayland";
    };
  };
}

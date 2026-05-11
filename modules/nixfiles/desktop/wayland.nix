{ lib, ... }:
{
  nf.desktop.wayland = {
    nixos =
      { pkgs, ... }:
      {
        environment = {
          systemPackages = [ pkgs.wl-clipboard-rs ];

          variables = {
            NIXOS_OZONE_WL = "1";
            GDK_BACKEND = "wayland,x11";
            ANKI_WAYLAND = "1";
            MOZ_ENABLE_WAYLAND = "1";
            XDG_SESSION_TYPE = "wayland";
            SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
          };

          sessionVariables = {
            KWIN_DRM_NO_AMS = "1";
            PROTON_ENABLE_WAYLAND = "1";
            SDL_VIDEODRIVER = "wayland";
          };
        };

        programs.gamescope.args = lib.mkAfter [ "--expose-wayland" ];

        services.displayManager.sddm.wayland.enable = true;
      };
  };
}

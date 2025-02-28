{
  config,
  lib,
  pkgs,
  ...
}:
let
  regreet-run = pkgs.writeShellScriptBin "regreet-run" ''
    # export WLR_NO_HARDWARE_CURSORS=1
    # export GBM_BACKEND=nvidia-drm
    # export LIBVA_DRIVER_NAME=nvidia
    # export __GLX_VENDOR_LIBRARY_NAME=nvidia
    # export __GL_GSYNC_ALLOWED=1
    export __GL_VRR_ALLOWED=1

    ${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} -d -s -- ${lib.getExe config.programs.regreet.package}
  '';
in
{
  environment.systemPackages = with pkgs; [
    gruvbox-gtk-theme
    bibata-cursors
    papirus-icon-theme
  ];

  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        cursor_theme_name = "Bibata-Modern-Classic";
        font_name = "Lexend 12";
        theme_name = "Gruvbox-Dark-BL";
        icon_theme_name = "Papirus-Dark";
      };
    };
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe regreet-run}";
  };

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.greetd.enableGnomeKeyring = true;
}

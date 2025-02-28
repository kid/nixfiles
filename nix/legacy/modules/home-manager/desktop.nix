{ pkgs, ... }:
{

  gtk = {
    enable = true;
  };

  home.packages = with pkgs; [
    xclip
    chromium
    discord
    tdesktop # telegram
    wire-desktop
    feh
    nfs-utils
    # pmount
    pulsemixer
    portfolio
    # freecad
    prusa-slicer
    glxinfo
    deltachat-desktop
    proton-pass
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser = "firefox.desktop";
      in
      {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
      };
  };
}

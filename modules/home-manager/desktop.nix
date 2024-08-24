{ pkgs, ... }:
{
  xdg.configFile."xmobar/gruvbox-dark.xmobarrc".source = ./files/gruvbox-dark.xmobarrc;
  xresources.extraConfig = builtins.readFile ./files/gruvbox-dark.xresources;

  gtk = {
    enable = true;

    # gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # font = {
    #   name = "Roboto";
    #   package = pkgs.roboto;
    # };

    # theme = {
    #   name = "Gruvbox-Dark-BL";
    #   package = pkgs.gruvbox-gtk-theme;
    # };
  };

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #   };
  # };

  home.packages = with pkgs; [
    xclip
    rofi
    # (google-chrome-beta.override {
    #   commandLineArgs = [
    #     "--enable-features=WebUIDarkMode"
    #     "--force-dark-mode"
    #   ];
    # })
    chromium
    # _1password-gui
    discord
    # discord-canary
    # webcord
    # vesktop
    tdesktop # telegram
    polybar
    xorg.xmessage
    feh
    leftwm
    nfs-utils
    pmount
    pulsemixer
    portfolio
    # freecad
    prusa-slicer
    alacritty
    # wlr-randr
    glxinfo
    deltachat-desktop
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

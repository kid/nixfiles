{ config, pkgs, ... }:
{
  home.file.".xinitrc".source = ../files/xinitrc.sh;
  xdg.configFile."xmobar/gruvbox-dark.xmobarrc".source = ../files/gruvbox-dark.xmobarrc;
  xresources.extraConfig = builtins.readFile ../files/gruvbox-dark.xresources;

  programs.zsh.profileExtra = builtins.readFile ../files/zprofile.sh;

  gtk = {
    enable = true;
    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };
  };

  home.packages = with pkgs; [
    xclip
    kitty
    rofi
    (google-chrome-beta.override {
      commandLineArgs = [
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    })
    _1password-gui
    tdesktop # telegram
    polybar
    polybar-xmonad
    haskellPackages.xmonad
    haskellPackages.xmonad-dbus
    haskellPackages.xmonad-kid
    xorg.xmessage
    feh
    leftwm
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = let browser = "google-chrome-beta.desktop"; in
      {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
      };
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,window,ssh";
    };

    font = "FiraCode Nerd Font 11";
    theme = "gruvbox-dark";
    terminal = "kitty";
  };

  # TODO put this somewhere else
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };

    settings = {
      background = "#282828";
      foreground = "#ebdbb2";

      color0 = "#282828";
      color8 = "#928374";
      # DarkRed + Red";
      color1 = "#cc241d";
      color9 = "#fb4934";
      # DarkGreen + Green";
      color2 = "#98971a";
      color10 = "#b8bb26";
      # DarkYellow + Yellow";
      color3 = "#d79921";
      color11 = "#fabd2f";
      # DarkBlue + Blue";
      color4 = "#458588";
      color12 = "#83a598";
      # DarkMagenta + Magenta";
      color5 = "#b16286";
      color13 = "#d3869b";
      # DarkCyan + Cyan";
      color6 = "#689d6a";
      color14 = "#8ec07c";
      # LightGrey + White";
      color7 = "#a89984";
      color15 = "#ebdbb2";
    };
  };

}

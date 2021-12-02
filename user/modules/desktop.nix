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
    leftwm
    polybar
    polybar-xmonad
    haskellPackages.xmonad
    haskellPackages.xmonad-dbus
    haskellPackages.xmonad-kid
    xorg.xmessage
    feh
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
}

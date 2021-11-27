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
    (chromium.override {
      commandLineArgs = [
        "--enable-features=WebUIDarkMode"
        "--force-dark-mode"
      ];
    })
    _1password-gui
    tdesktop # telegram
    haskellPackages.xmonad
    haskellPackages.xmonad-kid
    haskellPackages.xmobar
    xorg.xmessage
    picom-next
    eww
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = let browser = "chromium-browser.desktop"; in
      {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
      };
  };
}

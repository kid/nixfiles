{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xclip
    chromium
    discord
    # tdesktop # telegram
    telegram-desktop
    wire-desktop
    feh
    nfs-utils
    # pmount
    pulsemixer
    portfolio
    freecad
    prusa-slicer
    # glxinfo
    deltachat-desktop
    proton-pass
    winbox4
  ];
}

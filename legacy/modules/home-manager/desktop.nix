{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xclip
    chromium
    discord
    telegram-desktop
    nfs-utils
    # pmount
    pulsemixer
    freecad
    prusa-slicer
    proton-pass
    winbox4
  ];
}

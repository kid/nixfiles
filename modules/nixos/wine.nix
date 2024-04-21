{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # bottles

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # native wayland support (unstable)
    wineWowPackages.waylandFull

    # winetricks (all versions)
    winetricks
  ];
}

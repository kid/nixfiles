{ pkgs, ... }:
{
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    legendary-gl
    lutris

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks and other programs depending on wine need to use the same wine version
    # (winetricks.override { wine = wineWowPackages.staging; })

    vulkan-tools
    vulkan-loader
    vulkan-validation-layers

    xorg.xrandr
  ];
}

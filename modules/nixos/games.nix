{ pkgs, ... }:
{
  programs.steam.enable = true;
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
  ];
}

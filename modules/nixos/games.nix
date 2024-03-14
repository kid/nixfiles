{ pkgs, ... }:
{
  programs.gamescope = {
    enable = true;
    capSysNice = false;
    # package = pkgs.gamescope-wsi;
  };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  # chaotic.steam.extraCompatPackages = with pkgs; [
  # ];

  # nixpkgs.config.packageOverrides = pkgs: {
  #   steam = pkgs.steam.override {
  #     extraPkgs = pkgs: with pkgs; [
  #       xorg.libXcursor
  #       xorg.libXi
  #       xorg.libXinerama
  #       xorg.libXScrnSaver
  #       libpng
  #       libpulseaudio
  #       libvorbis
  #       stdenv.cc.cc.lib
  #       libkrb5
  #       keyutils
  #     ];
  #   };
  # };

  environment.systemPackages = with pkgs; [
    gamemode
    legendary-gl
    lutris

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks and other programs depending on wine need to use the same wine version
    # (winetricks.override { wine = wineWowPackages.staging; })

    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    vulkan-hdr-layer

    xorg.xrandr

    ckan # mod manager for ksp
    steam-run
    protontricks
    mangohud
    dxvk
  ];
}

{ pkgs, ... }:
{
  programs.gamescope = {
    enable = true;
    capSysNice = false;
    # package = pkgs.gamescope_git;
  };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  # chaotic.steam.extraCompatPackages = with pkgs; [
  # ];

  programs.noisetorch.enable = true;

  environment.systemPackages = with pkgs; [
    steamtinkerlaunch
    gamemode
    # legendary-gl
    # lutris

    # wine-staging (version with experimental features)
    # wineWowPackages.staging

    # winetricks and other programs depending on wine need to use the same wine version
    # (winetricks.override { wine = wineWowPackages.staging; })

    # vulkan-tools
    # vulkan-loader
    # vulkan-validation-layers
    # vulkan-hdr-layer

    # xorg.xrandr

    ckan # mod manager for ksp
    # steam-run
    # protontricks
    mangohud
    dxvk
  ];
}

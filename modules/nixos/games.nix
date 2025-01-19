{ pkgs, ... }:
{
  programs = {
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 20;
        };
      };
    };
    gamescope = {
      enable = true;
      # capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = pkgs.steam.override {
        extraLibraries = pkgs: [ pkgs.xorg.libxcb ];
        extraPkgs =
          pkgs: with pkgs; [
            gamemode
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

    noisetorch.enable = true;
  };

  # hardware.xpadneo.enable = true;

  environment = {
    sessionVariables.MANGOHUD_CONFIG = "~/.config/MangoHud/MangoHud.conf";
    systemPackages = with pkgs; [
      # steamtinkerlaunch
      # gamemode
      # heroic
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

      # ckan # mod manager for ksp
      # steam-run
      # protontricks
      mangohud
      dxvk
    ];
  };
}

{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.nixfiles.programs.gaming;
in
{
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-cachyos_x86_64_v4
        proton-cachyos_nightly_x86_64_v4
      ];

      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            mangohud
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

      platformOptimizations.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}

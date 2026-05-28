{ inputs, ... }:
{
  nf.gaming = {
    nixos =
      { pkgs, ... }:
      {
        nix.settings = {
          extra-substituters = [ "https://nix-cache.tokidoki.dev/tokidoki" ];
          extra-trusted-public-keys = [ "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk=" ];
        };

        nixpkgs.overlays = [ inputs.nix-gaming-edge.overlays.default ];

        steam = {
          enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
            proton-cachyos
          ];
          package = pkgs.steam.override {
            extraPkgs =
              pkgs': with pkgs'; [
                mangohud
                gamemode
                libxcursor
                libxi
                libxinerama
                libxscrnsaver
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
      };
  };
}

{
  inputs,
  den,
  nf,
  ...
}:
{
  flake-file.inputs = {
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming-edge.url = "github:powerofthe69/nix-gaming-edge";
    nix-gaming-edge.inputs.nixpkgs.follows = "nixpkgs";
  };

  nf.desktop.gaming = {
    nixos =
      { pkgs, ... }:
      {
        imports = with inputs.nix-gaming.nixosModules; [
          wine
          pipewireLowLatency
          platformOptimizations
        ];

        nix.settings = {
          extra-substituters = [ "https://nix-cache.tokidoki.dev/tokidoki" ];
          extra-trusted-public-keys = [ "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk=" ];
        };

        nixpkgs.overlays = [ inputs.nix-gaming-edge.overlays.default ];

        programs = {
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

          gamemode = {
            enable = true;
            enableRenice = true;
            settings = {
              general = {
                softrealtime = "auto";
                renice = 10;
              };
              custom = {
                start = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'";
                end = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'";
              };
            };
          };

          wine = {
            enable = true;
            ntsync = true;
          };
        };

        services.pipewire.lowLatency.enable = true;

        environment.sessionVariables = {
          MESA_VK_WSI_PRESENT_MODE = "immediate";
          PROTON_USE_NTSYNC = 1;
        };
      };

    includes = [
      (den.lib.policy.when ({ host, ... }: host.hasAspect nf.desktop.wayland) {
        nixos =
          { lib, ... }:
          {
            programs.gamescope.args = lib.mkAfter [ "--expose-wayland" ];
          };

        homeManager = {
          home.sessionVariables = {
            PROTON_ENABLE_WAYLAND = "1";
            PROTON_ENABLE_HDR = "1";
          };
        };
      })
    ];
  };
}

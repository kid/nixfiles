{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks-nix.flakeModule
      ];

      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { config, pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ gnumake config.treefmt.build.wrapper fd nil ];
          shellHook = config.pre-commit.installationScript;
        };
        devshells.old = {

          packages = with pkgs; [ gnumake config.treefmt.build.wrapper fd nil ];

          commands = [
            {
              name = "fmt";
              help = "Check Nix formatting";
              command = "nixpkgs-fmt \${@} $PRJ_ROOT";
            }
            {
              name = "evalnix";
              help = "Check Nix parsing";
              command =
                "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
            }
            {
              name = "switch";
              command = ''
                case $OSTYPE in
                  darwin*)  switch-darwin ;;
                  linux*)   switch-nixos ;;
                  *)        echo \"unknown: $OSTYPE\"; exit 1 ;;
                esac
              '';
            }
            {
              name = "switch-nixos";
              command =
                "sudo nixos-rebuild switch --flake . && sudo bootctl set-default @saved";
            }
            {
              name = "switch-darwin";
              command = "TERM=xterm-256color darwin-rebuild switch --flake .";
            }
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          # build.check = true;
          flakeFormatter = true;
          programs.nixfmt.enable = true;
        };

        pre-commit.check.enable = true;
      };
      flake = {
        nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self inputs; };
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs = {
                config = {
                  allowBroken = true;
                  allowUnfree = true;
                };
                overlays = [
                  inputs.nur.overlay
                  # inputs.nil.overlays.default
                  # inputs.neovim.overlay
                  # inputs.neovim-nightly-overlay.overlay
                  # inputs.leftwm.overlay
                  (final: prev: {
                    # fcitx-engines = final.fcitx5;
                    vulkan-hdr-layer =
                      prev.callPackage ./pkgs/vulkan-hdr-layer.nix { };
                    # steam = prev.steam.override {
                    #   extraPkgs = pkgs: with pkgs; [
                    #     xorg.libXcursor
                    #     xorg.libXi
                    #     xorg.libXinerama
                    #     xorg.libXScrnSaver
                    #     libpng
                    #     libpulseaudio
                    #     libvorbis
                    #     stdenv.cc.cc.lib
                    #     libkrb5
                    #     keyutils
                    #   ];
                    # };
                  })
                ];
              };
            }
            inputs.nur.nixosModules.nur
            inputs.hm.nixosModule
            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-gpu-amd
            inputs.stylix.nixosModules.stylix
            # { hardware.amdgpu.amdvlk = true; }
            {
              hardware.amdgpu.loadInInitrd = true;
            }
            # inputs.hyprland.nixosModules.default
            inputs.chaotic.nixosModules.default
            ./hosts/nixos.nix
            ./modules/nixos
            ./modules/nixos/desktop.nix
            ./modules/nixos/games.nix
            # ./modules/nixos/podman.nix
            # ./modules/nixos/containerd.nix
            ./modules/nixos/docker.nix
            ./modules/nixos/virtualization.nix
            ./modules/nixos/printing.nix
            # ./profiles/desktop.nix
            # ./profiles/hyprland.nix
            ./profiles/plasma6.nix
            { home-manager.extraSpecialArgs = { inherit inputs; }; }
          ];
        };
        darwinConfigurations.mbp = inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            inputs.hm.darwinModules.home-manager
            inputs.stylix.darwinModules.stylix
            ./modules/darwin
            ./profiles/work.nix
            ({ pkgs, ... }: {
              nixpkgs = {
                config = {
                  allowBroken = true;
                  allowUnfree = true;
                };
                overlays =
                  [ inputs.nur.overlay inputs.nixpkgs-firefox-darwin.overlay ];
              };
              hm.programs.firefox.package = pkgs.firefox-bin;
            })
          ];
        };
      };
    };
  # let
  #   inherit (fup.lib) exportOverlays exportModules;
  #   username = "kid";
  # in
  # fup.lib.mkFlake {
  #   inherit self inputs;
  #
  #   channelsConfig = {
  #     allowUnfree = true;
  #     allowBroken = true;
  #     permittedInsecurePackages = [ "xpdf-4.04" ];
  #   };
  #
  #   # channels.default.input.nixpkgs.config.packageOverrides = pkgs: {
  #   #   steam = pkgs.steam.override {
  #   #     extraPkgs = pkgs: with pkgs; [
  #   #       xorg.libXcursor
  #   #       xorg.libXi
  #   #       xorg.libXinerama
  #   #       xorg.libXScrnSaver
  #   #       libpng
  #   #       libpulseaudio
  #   #       libvorbis
  #   #       stdenv.cc.cc.lib
  #   #       libkrb5
  #   #       keyutils
  #   #     ];
  #   #   };
  #   # };
  #   #
  #   # Propagates to channels.<name>.overlaysBuilder
  #   sharedOverlays = [
  #     # self.overlay
  #     inputs.devshell.overlays.default
  #     # inputs.hyprland.overlays.default
  #     # inputs.hyprland-contrib.overlays.default
  #     # inputs.hyprpaper.overlays.default
  #     inputs.nil.overlays.default
  #     inputs.neovim.overlay
  #     # inputs.neovim-nightly-overlay.overlay
  #     inputs.leftwm.overlay
  #     (final: prev: {
  #       # fcitx-engines = final.fcitx5;
  #       vulkan-hdr-layer = prev.callPackage ./pkgs/vulkan-hdr-layer.nix { };
  #       # steam = prev.steam.override {
  #       #   extraPkgs = pkgs: with pkgs; [
  #       #     xorg.libXcursor
  #       #     xorg.libXi
  #       #     xorg.libXinerama
  #       #     xorg.libXScrnSaver
  #       #     libpng
  #       #     libpulseaudio
  #       #     libvorbis
  #       #     stdenv.cc.cc.lib
  #       #     libkrb5
  #       #     keyutils
  #       #   ];
  #       # };
  #     })
  #     # inputs.nixpkgs-wayland.overlay
  #     # outputs.overlays.additions
  #   ];
  #
  #   nixosModules = exportModules [
  #     ./hosts/nixos.nix
  #   ];
  #
  #   # overlay = import ./overlays { inherit inputs; };
  #   overlays = exportOverlays {
  #     inherit (self) pkgs;
  #   };
  #   # overlays = import ./overlays { inherit inputs; };
  #
  #   hosts = {
  #     nixos = {
  #       specialArgs = { inherit self inputs; };
  #       modules = [
  #         inputs.hm.nixosModule
  #         inputs.nixos-hardware.nixosModules.common-pc
  #         inputs.nixos-hardware.nixosModules.common-pc-ssd
  #         inputs.nixos-hardware.nixosModules.common-cpu-amd
  #         inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
  #         inputs.nixos-hardware.nixosModules.common-gpu-amd
  #         inputs.stylix.nixosModules.stylix
  #         # { hardware.amdgpu.amdvlk = true; }
  #         { hardware.amdgpu.loadInInitrd = true; }
  #         inputs.hyprland.nixosModules.default
  #         inputs.chaotic.nixosModules.default
  #         ./hosts/nixos.nix
  #         ./modules/nixos
  #         ./modules/nixos/desktop.nix
  #         ./modules/nixos/games.nix
  #         # ./modules/nixos/podman.nix
  #         # ./modules/nixos/containerd.nix
  #         ./modules/nixos/docker.nix
  #         ./modules/nixos/virtualization.nix
  #         ./modules/nixos/printing.nix
  #         # ./profiles/desktop.nix
  #         ./profiles/hyprland.nix
  #         {
  #           home-manager.extraSpecialArgs = { inherit inputs; };
  #         }
  #         # {
  #         #   hm.imports = [
  #         #     inputs.hyprland.homeManagerModules.default
  #         #   ];
  #         # }
  #       ];
  #     };
  #     mbp = {
  #       builder = darwin.lib.darwinSystem;
  #       output = "darwinConfigurations";
  #       system = "aarch64-darwin";
  #       modules = [
  #         inputs.hm.darwinModules.home-manager
  #         inputs.stylix.darwinModules.stylix
  #         ./modules/darwin
  #         ./profiles/work.nix
  #       ];
  #     };
  #   };
  # };
  #
  # nixConfig = {
  #   extra-substituters = [
  #     "https://hyprland.cachix.org"
  #   ];
  #   extra-trusted-public-keys = [
  #     "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #   ];
  # };
}

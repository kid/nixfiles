{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    # nixpkgs.url = "github:nixos/nixpkgs/7fa1a3c6b3d22f5e53bb765518a749847a25bb65";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    disko.url = "github:nix-community/disko/latest";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    # chaotic.url = "github:chaotic-cx/nyx/b1ecb501161bae54fbc9fd27200bd34d40c4a47a";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs";

    # nixvim.url = "github:nix-community/nixvim";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:kid/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";

    plasma-manager = {
      url = "github:pjones/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall = {
        root = ./nix;

        namespace = "nixfiles";
      };

      systems = {
        modules = {
          nixos = with inputs; [
            disko.nixosModules.disko
            stylix.nixosModules.stylix
            impermanence.nixosModules.impermanence
          ];
        };
      };

      outputs-builder = channels: {
        formatter = inputs.treefmt-nix.lib.mkWrapper channels.nixpkgs ./treefmt.nix;
      };
    };

  # outputs =
  #   inputs@{ self, flake-parts, ... }:
  #   flake-parts.lib.mkFlake { inherit inputs; } {
  #     imports = [
  #       inputs.devshell.flakeModule
  #       inputs.treefmt-nix.flakeModule
  #       inputs.pre-commit-hooks-nix.flakeModule
  #     ];
  #
  #     systems = [
  #       "x86_64-linux"
  #       "aarch64-darwin"
  #     ];
  #
  #     perSystem =
  #       { config, pkgs, ... }:
  #       {
  #         devShells.default = pkgs.mkShell {
  #           packages = with pkgs; [
  #             gnumake
  #             config.treefmt.build.wrapper
  #             fd
  #             nil
  #             just
  #           ];
  #           shellHook = config.pre-commit.installationScript;
  #         };
  #         devshells.old = {
  #           packages = with pkgs; [
  #             gnumake
  #             config.treefmt.build.wrapper
  #             fd
  #             nil
  #           ];
  #
  #           commands = [
  #             {
  #               name = "fmt";
  #               help = "Check Nix formatting";
  #               command = "nixpkgs-fmt \${@} $PRJ_ROOT";
  #             }
  #             {
  #               name = "evalnix";
  #               help = "Check Nix parsing";
  #               command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
  #             }
  #             {
  #               name = "switch";
  #               command = ''
  #                 case $OSTYPE in
  #                   darwin*)  switch-darwin ;;
  #                   linux*)   switch-nixos ;;
  #                   *)        echo \"unknown: $OSTYPE\"; exit 1 ;;
  #                 esac
  #               '';
  #             }
  #             {
  #               name = "switch-nixos";
  #               command = "sudo nixos-rebuild switch --flake . && sudo bootctl set-default @saved";
  #             }
  #             {
  #               name = "switch-darwin";
  #               command = "TERM=xterm-256color darwin-rebuild switch --flake .";
  #             }
  #           ];
  #         };
  #
  #         treefmt = {
  #           projectRootFile = "flake.nix";
  #           # build.check = true;
  #           flakeFormatter = true;
  #           programs.nixfmt.enable = true;
  #           programs.nixfmt.package = pkgs.nixfmt-rfc-style;
  #           programs.just.enable = true;
  #         };
  #
  #         pre-commit.check.enable = true;
  #       };
  #     flake = {
  #       overlays = import ./overlays { inherit inputs; };
  #       nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
  #         specialArgs = {
  #           inherit self inputs;
  #         };
  #         system = "x86_64-linux";
  #         modules = [
  #           {
  #             nixpkgs = {
  #               config = {
  #                 allowBroken = true;
  #                 allowUnfree = true;
  #               };
  #               overlays = [
  #                 self.overlays.stable-packages
  #                 inputs.nur.overlays.default
  #                 # inputs.nil.overlays.default
  #                 # inputs.neovim.overlay
  #                 # inputs.neovim-nightly-overlay.overlay
  #                 # inputs.leftwm.overlay
  #                 (final: prev: {
  #                   # fcitx-engines = final.fcitx5;
  #                   # vulkan-hdr-layer =
  #                   #   prev.callPackage ./pkgs/vulkan-hdr-layer.nix { };
  #                   # steam = prev.steam.override {
  #                   #   extraPkgs = pkgs: with pkgs; [
  #                   #     xorg.libXcursor
  #                   #     xorg.libXi
  #                   #     xorg.libXinerama
  #                   #     xorg.libXScrnSaver
  #                   #     libpng
  #                   #     libpulseaudio
  #                   #     libvorbis
  #                   #     stdenv.cc.cc.lib
  #                   #     libkrb5
  #                   #     keyutils
  #                   #   ];
  #                   # };
  #                   # nixos-icons = final.stable.nixos-icons;
  #                 })
  #               ];
  #             };
  #           }
  #           ./hosts/nixos.nix
  #         ];
  #       };
  #       darwinConfigurations.mbp = inputs.darwin.lib.darwinSystem {
  #         system = "aarch64-darwin";
  #         specialArgs = {
  #           inherit self inputs;
  #         };
  #         modules = [ ./hosts/mbp.nix ];
  #       };
  #     };
  #   };
}

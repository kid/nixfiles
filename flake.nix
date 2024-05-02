{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-unstable";

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

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { config, pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              gnumake
              config.treefmt.build.wrapper
              fd
              nil
            ];
            shellHook = config.pre-commit.installationScript;
          };
          devshells.old = {

            packages = with pkgs; [
              gnumake
              config.treefmt.build.wrapper
              fd
              nil
            ];

            commands = [
              {
                name = "fmt";
                help = "Check Nix formatting";
                command = "nixpkgs-fmt \${@} $PRJ_ROOT";
              }
              {
                name = "evalnix";
                help = "Check Nix parsing";
                command = "fd --extension nix --exec nix-instantiate --parse --quiet {} >/dev/null";
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
                command = "sudo nixos-rebuild switch --flake . && sudo bootctl set-default @saved";
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
            programs.nixfmt.package = pkgs.nixfmt-rfc-style;
          };

          pre-commit.check.enable = true;
        };
      flake = {
        overlays = import ./overlays { inherit inputs; };
        nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self inputs;
          };
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs = {
                config = {
                  allowBroken = true;
                  allowUnfree = true;
                };
                overlays = [
                  self.overlays.stable-packages
                  inputs.nur.overlay
                  # inputs.nil.overlays.default
                  # inputs.neovim.overlay
                  # inputs.neovim-nightly-overlay.overlay
                  # inputs.leftwm.overlay
                  (final: prev: {
                    # fcitx-engines = final.fcitx5;
                    # vulkan-hdr-layer =
                    #   prev.callPackage ./pkgs/vulkan-hdr-layer.nix { };
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
                    nixos-icons = final.stable.nixos-icons;
                  })
                ];
              };
            }
            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-gpu-amd
            inputs.hm.nixosModule
            inputs.nur.nixosModules.nur
            inputs.stylix.nixosModules.stylix
            inputs.xremap.nixosModules.default
            # { hardware.amdgpu.amdvlk = true; }
            { hardware.amdgpu.loadInInitrd = true; }
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
            # { home-manager.extraSpecialArgs = { inherit inputs; }; }
          ];
        };
        darwinConfigurations.M-Y47D2M27VX = inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit self inputs;
          };
          modules = [ ./hosts/mbp.nix ];
        };
      };
    };
}

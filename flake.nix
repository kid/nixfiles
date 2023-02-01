{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    # nixpkgs-darwin-stable.url = github:nixos/nixpkgs/nixpkgs-21.11-darwin;

    nixos-hardware.url = github:nixos/nixos-hardware;

    fu.url = github:numtide/flake-utils;
    fup.url = github:gytis-ivaskevicius/flake-utils-plus;
    fup.inputs.flake-utils.follows = "fu";

    hm.url = github:nix-community/home-manager/release-22.05;
    hm.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = github:lnl7/nix-darwin/master;
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = github:numtide/devshell;
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "fu";

    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
      inputs.naersk.follows = "naersk";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    leftwm.url = github:kid/leftwm/display-name;
    leftwm.inputs.nixpkgs.follows = "nixpkgs";
    leftwm.inputs.flake-utils.follows = "fu";
    leftwm.inputs.naersk.follows = "naersk";
  };

  outputs = inputs @ { self, fup, darwin, ... }:
    let
      inherit (fup.lib) exportOverlays exportPackages exportModules;
      username = "kid";
    in
    fup.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;
      channelsConfig.allowBroken = true;

      # Propagates to channels.<name>.overlaysBuilder
      sharedOverlays = [
        self.overlay
        inputs.devshell.overlay
        inputs.neovim-nightly-overlay.overlay
        inputs.leftwm.overlay
      ];

      nixosModules = exportModules [
        ./hosts/nixos.nix
      ];

      overlay = import ./overlays { inherit inputs; };
      overlays = exportOverlays {
        inherit (self) pkgs;
        inputs = (builtins.removeAttrs inputs [ "xmonad" "xmonad-contrib" ]);
      };

      outputsBuilder = channels: {
        packages = exportPackages self.overlays channels;
        devShell = channels.nixpkgs.devshell.mkShell {
          name = "nixfiles";

          packages = with channels.nixpkgs; [
            gnumake
            nixpkgs-fmt
            rnix-lsp
            fd
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
              command = "
                case $OSTYPE in
                  darwin*)  switch-darwin ;;
                  linux*)   switch-nixos ;;
                  *)        echo \"unknown: $OSTYPE\"; exit 1 ;;
                esac
              ";
            }
            {
              name = "switch-nixos";
              command = "sudo nixos-rebuild switch --flake .";
            }
            {
              name = "switch-darwin";
              command = "TERM=xterm-256color darwin-rebuild switch --flake .";
            }
          ];
        };
      };

      hosts = {
        nixos.modules = [
          inputs.hm.nixosModule
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          ./hosts/nixos.nix
          ./modules/nixos
          ./modules/nixos/desktop.nix
          ./modules/nixos/games.nix
          ./modules/nixos/podman.nix
          ./profiles/desktop.nix
        ];
        M-Y47D2M27VX = {
          builder = darwin.lib.darwinSystem;
          output = "darwinConfigurations";
          system = "aarch64-darwin";
          modules = [
            inputs.hm.darwinModules.home-manager
            ./modules/darwin
            ./profiles/work.nix
          ];
        };
      };

      homeConfigurations =
        let
          configuration = {
            programs.home-manager.enable = true;
          };
          extraSpecialArgs = { inherit inputs self; };
          generateHome = inputs.hm.lib.homeManagerConfiguration;
          system = "x86_64-linux";
          pkgs = self.pkgs.${system}.nixpkgs;
        in
        {
          "${username}@M-Y47D2M27VX" = generateHome {
            inherit username extraSpecialArgs pkgs configuration;
            homeDirectory = "/Users/${username}";
            system = "aarch64-darwin";
          };
        };
    };
}

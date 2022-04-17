{
  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;

    nixos-hardware.url = github:nixos/nixos-hardware;

    fu.url = github:numtide/flake-utils;
    fup.url = github:gytis-ivaskevicius/flake-utils-plus;
    fup.inputs.flake-utils.follows = "fu";

    hm.url = github:nix-community/home-manager;
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

    # rust-overlay = {
    #   url = github:oxalica/rust-overlay;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.utils.follows = "fu";
    # };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    leftwm.url = github:leftwm/leftwm;
    leftwm.inputs.nixpkgs.follows = "nixpkgs";
    leftwm.inputs.flake-utils.follows = "fu";
    leftwm.inputs.fenix.follows = "fenix";
    leftwm.inputs.naersk.follows = "naersk";
  };

  outputs = inputs @ { self, nixpkgs, fup, darwin, ... }:
    let
      inherit (fup.lib) exportOverlays exportPackages exportModules;
      username = "kid";

      shared = [
        ./home
      ];

      hmModules = {
        inherit shared;
        arch-nix = shared ++ [ ./home/profiles/minimal.nix ];
        nixos = shared ++ [ ./home/profiles/desktop.nix ];
      };
    in
    fup.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      # Propagates to channels.<name>.overlaysBuilder
      sharedOverlays = [
        self.overlay
        inputs.devshell.overlay
        inputs.neovim-nightly-overlay.overlay
        # inputs.rust-overlay.overlay
        inputs.leftwm.overlay
        inputs.fenix.overlay
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
              command = "sudo nixos-rebuild switch --flake .";
            }
            {
              name = "switch-local";
              command = "sudo nixos-rebuild switch --flake . --option binary-caches ''";
            }
          ];
        };
      };

      hostDefaults.modules = [
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          # user.name = username;
        }
      ];

      hosts = {
        nixos.modules = [
          ./modules/minimal.nix
          inputs.hm.nixosModule
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          ./hosts/nixos.nix
          ./modules/desktop.nix
          ./modules/games.nix
          { user.name = username; }
          { home-manager.users."${username}".imports = hmModules.nixos; }
        ];
        BRUS-73864-Y47D2M27VX = {
          builder = darwin.lib.darwinSystem;
          output = "darwinConfigurations";
          system = "aarch64-darwin";
          modules = [
            # darwin.darwinModules.simple
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
          homeDirectory = "/home/${username}";
          generateHome = inputs.hm.lib.homeManagerConfiguration;
          system = "x86_64-linux";
          pkgs = self.pkgs.${system}.nixpkgs;
        in
        {
          cli = generateHome {
            inherit system username homeDirectory extraSpecialArgs pkgs configuration;
            extraModules = [ ./home/profiles/cli.nix ];
          };

          "${username}@arch-nix" = generateHome {
            inherit system username homeDirectory extraSpecialArgs pkgs configuration;
            extraModules = hmModules.arch-nix;
          };

          "$(username}@BRUS-73864-Y47D2M27VX" = generateHome {
            inherit username extraSpecialArgs pkgs configuration;
            homeDirectory = "/Users/${username}";
            system = "aarch64-darwin";
          };
        };
    };
}

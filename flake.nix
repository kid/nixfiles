{
  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-21.11;
    latest.url = github:nixos/nixpkgs/nixos-unstable;

    nixos-hardware.url = github:nixos/nixos-hardware;

    fu.url = github:numtide/flake-utils;
    fup.url = github:gytis-ivaskevicius/flake-utils-plus;
    fup.inputs.flake-utils.follows = "fu";

    hm.url = github:nix-community/home-manager/release-21.05;
    hm.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = github:numtide/devshell;
    neovim-nightly-overlay.url = github:nix-community/neovim-nightly-overlay;
    rnix-lsp = {
      url = github:nix-community/rnix-lsp;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
    };

    xmonad.url = github:xmonad/xmonad;
    xmonad-contrib.url = github:xmonad/xmonad-contrib;
    xmonad-contrib.inputs.xmonad.follows = "xmonad";
    xmonad-kid.url = github:kid/xmonad;
    xmonad-kid.inputs.xmonad.follows = "xmonad";
    xmonad-kid.inputs.xmonad-contrib.follows = "xmonad-contrib";
  };

  outputs = inputs @ { self, nixpkgs, fup, ... }:
    let
      inherit (fup.lib) exportOverlays exportPackages exportModules;
      username = "kid";

      shared = [
        ./home/cli.nix
      ];

      hmModules = {
        inherit shared;
        arch-nix = shared;
        nixos = shared ++ [
          ./home/fonts.nix
          ./home/desktop.nix
        ];
      };
    in
    fup.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;
      # Channel specific overlays. 
      # channels.nixpkgs.overlaysBuilder = channels: [
      #   (final: prev: { })
      # ];

      # Propagates to channels.<name>.overlaysBuilder
      sharedOverlays = [
        self.overlay
        inputs.devshell.overlay
        inputs.neovim-nightly-overlay.overlay
        inputs.xmonad.overlay
        inputs.xmonad-contrib.overlay
        inputs.xmonad-kid.overlay
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
          packages = with channels.nixpkgs; [
            gnumake
            nixpkgs-fmt
            rnix-lsp
          ];
          name = "nixfiles";
        };
      };

      hostDefaults.channelName = "latest";
      hostDefaults.modules = [
        ./modules/minimal.nix
        inputs.hm.nixosModule
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          user.name = username;
        }
      ];

      hosts = {
        nixos.modules = [
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          ./hosts/nixos.nix
          ./modules/desktop.nix
          ./modules/games.nix
          { home-manager.users."${username}".imports = hmModules.nixos; }
        ];
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
            extraModules = [ ./home/cli.nix ];
          };

          "${username}@arch-nix" = generateHome {
            inherit system username homeDirectory extraSpecialArgs pkgs configuration;
            extraModules = hmModules.arch-nix;
          };
        };
    };
}

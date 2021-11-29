{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    neovim-nightly-overlay = {
      url = github:nix-community/neovim-nightly-overlay;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xmonad-kid = {
      url = github:kid/xmonad;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # xmobar-kid = {
    #   url = path:./configs/xmobar;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # taffybar-kid = {
    #   url = path:./configs/taffybar;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , utils
    , home-manager
    , nixos-hardware
    , neovim-nightly-overlay
    , xmonad-kid
      # , xmobar-kid
      # , taffybar-kid
    , ...
    }:
    let 
      username = "kid";
      overlays = [ neovim-nightly-overlay.overlay ]
        ++ xmonad-kid.overlays
        # ++ xmobar-kid.overlays 
        # ++ taffybar-kid.overlays
        ;
    in
    utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = overlays;

      channelsConfig.allowUnfree = true;

      channels.nixpkgs.inputs = nixpkgs;

      hostDefaults.channelName = "nixpkgs";
      hostDefaults.modules = [
        ./system/modules
        ./system/modules/options.nix
        {
          services.openssh.enable = true;
        }
        {
          user.name = username;
        }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      hosts.nixos.modules = [
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-cpu-amd
        ./system/hosts/nixos.nix
        ./system/modules/desktop.nix
        ./system/modules/games.nix
      ];

      hosts.test-vm.modules = [
        ./system/hosts/test-vm.nix
      ];

      homeConfigurations = {
        "${username}@arch-nix" = home-manager.lib.homeManagerConfiguration {
          inherit username;
          system = "x86_64-linux";
          homeDirectory = "/home/${username}";
          configuration.nixpkgs.overlays = overlays;
          configuration.imports = [ 
            ./user/modules/shell.nix
            ./user/modules/editor.nix
          ];
        };
        "${username}@lenovo" = home-manager.lib.homeManagerConfiguration {
          inherit username;
          system = "x86_64-linux";
          homeDirectory = "/home/${username}";
          configuration.nixpkgs.overlays = overlays;
          configuration.imports = [ 
            ./user/modules/shell.nix
            ./user/modules/editor.nix
          ];
        };
      };

      outputsBuilder = channels: with channels.nixpkgs; {
        devShell = mkShell {
          buildInputs = [
            fup-repl
            nixpkgs-fmt
          ];
        };
      };
    };
}

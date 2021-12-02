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

    leftwm = {
      url = github:leftwm/leftwm;
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , utils
    , home-manager
    , nixos-hardware
    , neovim-nightly-overlay
    , xmonad-kid
    , leftwm
    , ...
    }:
    let
      username = "kid";
      overlay = final: prev: {
        leftwm = prev.leftwm.overrideAttrs (old: rec {
          src = leftwm;
          cargoBuildFlags = [ "--features=journald" ];
          buildInputs = old.buildInputs ++ [ final.systemd ];
          postInstall = old.postInstall + ''
            for p in $out/bin/leftwm*; do
              patchelf --set-rpath "${final.lib.makeLibraryPath [(prev.lib.getLib final.systemd)]}" $p
            done
          '';
          nativeBuildInputs = old.nativeBuildInputs ++ [ final.pkg-config ];
        });
      };
      overlays = [ overlay neovim-nightly-overlay.overlay ] ++ xmonad-kid.overlays;
    in
    utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = overlays;

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
      };

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

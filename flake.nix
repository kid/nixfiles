{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    fu.url = "github:numtide/flake-utils";
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
    fup.inputs.flake-utils.follows = "fu";

    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "fu";
      inputs.naersk.follows = "naersk";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    leftwm.url = "github:kid/leftwm/display-name";
    leftwm.inputs.nixpkgs.follows = "nixpkgs";
    leftwm.inputs.flake-utils.follows = "fu";
    leftwm.inputs.naersk.follows = "naersk";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs @ { self, fup, darwin, ... }:
    let
      inherit (fup.lib) exportOverlays exportModules;
      username = "kid";
    in
    fup.lib.mkFlake {
      inherit self inputs;

      channelsConfig = {
        allowUnfree = true;
        allowBroken = true;
        permittedInsecurePackages = [ "xpdf-4.04" ];
      };

      # Propagates to channels.<name>.overlaysBuilder
      sharedOverlays = [
        self.overlay
        inputs.devshell.overlays.default
        inputs.hyprland.overlays.default
        inputs.hyprland-contrib.overlays.default
        inputs.hyprpaper.overlays.default
        inputs.nil.overlays.default
        inputs.neovim.overlay
        # inputs.neovim-nightly-overlay.overlay
        inputs.leftwm.overlay
        (self: super: {
          fcitx-engines = self.fcitx5;
        })
      ];

      nixosModules = exportModules [
        ./hosts/nixos.nix
      ];

      overlay = import ./overlays { inherit inputs; };
      overlays = exportOverlays {
        inherit (self) pkgs;
      };

      outputsBuilder = channels: {
        # packages = exportPackages self.overlays channels;
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
              command = "sudo nixos-rebuild switch --flake . && sudo bootctl set-default @saved";
            }
            {
              name = "switch-darwin";
              command = "TERM=xterm-256color darwin-rebuild switch --flake .";
            }
          ];
        };
      };

      hosts = {
        nixos = {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.hm.nixosModule
            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-gpu-amd
            { hardware.amdgpu.amdvlk = true; }
            { hardware.amdgpu.loadInInitrd = true; }
            inputs.hyprland.nixosModules.default
            ./hosts/nixos.nix
            ./modules/nixos
            ./modules/nixos/desktop.nix
            ./modules/nixos/games.nix
            ./modules/nixos/podman.nix
            ./modules/nixos/containerd.nix
            ./modules/nixos/virtualization.nix
            ./modules/nixos/printing.nix
            # ./profiles/desktop.nix
            ./profiles/hyprland.nix
            # {
            #   hm.extraSpecialArgs = { inherit inputs; };
            # }
            # {
            #   hm.imports = [
            #     inputs.hyprland.homeManagerModules.default
            #   ];
            # }
          ];
        };
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

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}

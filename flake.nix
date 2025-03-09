{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    ucodenix.url = "github:e-tho/ucodenix";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nur.url = "github:nix-community/NUR";

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:kid/nixvim";

    plasma-manager = {
      url = "github:pjones/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    inputs:
    let
      inherit (inputs) self snowfall-lib;

      lib = snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "nixfiles";
            title = "nixfiles";
          };
          namespace = "nixfiles";
        };

      };
    in
    (lib.mkFlake {

      channels-config = {
        allowUnfree = true;
      };

      homes.modules = with inputs; [
        plasma-manager.homeManagerModules.plasma-manager
        sops-nix.homeManagerModules.sops
      ];

      # home.users."kid@nixos".modules = with inputs; [
      #   # Default to enabled and require a config
      #   xremap.homeManagerModules.default
      # ];

      systems.modules = {
        darwin = with inputs; [
          sops-nix.darwinModules.sops
        ];
        nixos = with inputs; [
          nixos-facter-modules.nixosModules.facter
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          stylix.nixosModules.stylix
          ucodenix.nixosModules.default
          sops-nix.nixosModules.sops
          nixvim.nixosModules.nixvim
          nixvim.nixosModules.config
          # xremap.nixosModules.default
        ];
      };

      deploy = lib.mkDeploy {
        inherit self;
        overrides.pve0.hostname = "pve0.kidibox.net";
      };

      outputs-builder = channels: {
        formatter = inputs.treefmt-nix.lib.mkWrapper channels.nixpkgs ./treefmt.nix;
        # checks =
        #   let
        #     inherit (channels.nixpkgs) system;
        #     # FIXME: need to filter on system
        #     # deploy = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
        #     nixosMachines = lib.mapAttrs' (
        #       name: config: lib.nameValuePair "nixosConfiguration-${name}" config.config.system.build.toplevel
        #     ) ((lib.filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
        #     # devShells = lib.mapAttrs' (n: lib.nameValuePair "devShells-${n}") self.devShells;
        #   in
        #   nixosMachines;
      };
    })
    // {
      herculesCI = {
        ciSystems = [ "x86_64-linux" ];
      };
    };
}

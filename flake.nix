{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    easy-hosts.url = "github:tgirlcloud/easy-hosts";
    make-shell.url = "github:nicknovitski/make-shell";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    ucodenix.url = "github:e-tho/ucodenix";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";

    auto-cpufreq.url = "github:AdnanHodzic/auto-cpufreq";
    auto-cpufreq.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    neovim-flake.url = "github:kid/neovim";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager = {
      url = "github:pjones/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.3";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }: flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./flake ]; };
}

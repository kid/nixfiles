{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.default
    inputs.flake-file.flakeModules.import-tree
  ];

  flake-file.inputs = {
    flake-file.url = lib.mkDefault "github:vic/flake-file";

    flake-parts.url = lib.mkDefault "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = lib.mkDefault "nixpkgs-lib";

    nixpkgs.url = lib.mkDefault "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = lib.mkDefault "nixpkgs";
  };

  flake-file.outputs = "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./den)";

  systems = [
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-linux"
  ];
}

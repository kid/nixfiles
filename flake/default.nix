{
  self,
  inputs,
  moduleWithSystem,
  withSystem,
  flake-parts-lib,
  ...
}:
let
  inherit (flake-parts-lib) importApply;

  lib = import ../../lib {
    inherit (inputs.nixpkgs) lib;
  };

  localFlake = {
    inherit
      self
      inputs
      moduleWithSystem
      withSystem
      lib
      ;
    nixfiles = self;
  };
in
{
  imports = [
    ./checks/formatting.nix
    ./lib
    (importApply ./modules.nix localFlake)
    ./programs/treefmt.nix
    ./shells
    ./systems.nix
  ];

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
}

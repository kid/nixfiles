{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) treefmt-nix;
  treefmt = treefmt-nix.lib.evalModule pkgs ../../treefmt.nix;
in
treefmt.config.build.check inputs.self

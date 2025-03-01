{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule mkOpt;
in
mkModule ./. false config
  {
    package = mkOpt lib.types.package pkgs.nixVersions.latest "Which nix package to use.";
  }
  (_cfg: {
    environment.systemPackages = with pkgs; [
      cachix
      deploy-rs
      # nix-prefetch-nix
    ];
  })

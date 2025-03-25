{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nixfiles) mkOpt;
  cfg = config.nixfiles.nix;
in
{
  options.nixfiles.nix = {
    enable = mkEnableOption "nix";
    package = mkOpt lib.types.package pkgs.nixVersions.latest "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cachix
      deploy-rs
      # nix-prefetch-nix
    ];
  };
}

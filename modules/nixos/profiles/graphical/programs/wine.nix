{
  lib,
  localLib,
  pkgs,
  config,
  ...
}:
let
  inherit (localLib.programs) mkProgram;
  inherit (localLib.validators) isWayland;
  inherit (lib.lists) optional;

  cfg = config.nixfiles.programs.wine;
in
{
  options.nixfiles.programs.wine = mkProgram pkgs "wine" {
    package.default =
      if isWayland config then pkgs.wineWowPackages.waylandFull else pkgs.wineWowPackages.stableFull;
  };

  # determine which version of wine to use
  config.environment.systemPackages = optional cfg.enable cfg.package;
}

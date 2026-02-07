{
  lib,
  localLib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (localLib.validators) hasProfile isWayland;
in
{
  config =
    mkIf ((hasProfile config [ "graphical" ]) && (hasProfile config [ "laptop" ]) && (isWayland config))
      {
        programs.niri = {
          enable = false;
          package = pkgs.niri-unstable;
        };
      };
}

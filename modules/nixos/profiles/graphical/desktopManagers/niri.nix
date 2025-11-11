{
  lib,
  self,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib.validators) hasProfile isWayland;
in
{
  config =
    mkIf ((hasProfile config [ "graphical" ]) && (hasProfile config [ "laptop" ]) && (isWayland config))
      {
        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };
      };
}

{
  lib,
  self,
  config,
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
        programs = {
          niri.enable = true;
          # niri.package = pkgs.niri-unstable;
        };
      };
}

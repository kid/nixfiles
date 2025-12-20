{
  lib,
  localLib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (localLib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "headless" ]) {
    nixfiles = {
      packages = with pkgs; {
        ghostty-terminfo = ghostty.terminfo;
        kitty-terminfo = kitty.terminfo;
        wezterm-terminfo = wezterm.terminfo;
      };
    };
  };
}

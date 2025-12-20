{
  localLib,
  pkgs,
  ...
}:
let
  inherit (localLib.programs) mkProgram;
in
{
  options.nixfiles.programs = {
    bash = mkProgram pkgs "bash" {
      package.default = pkgs.bashInteractive;
    };

    zsh = mkProgram pkgs "zsh" {
      enable.default = true;
    };

    fish = mkProgram pkgs "fish" { };

    nushell = mkProgram pkgs "nushell" { };
  };
}

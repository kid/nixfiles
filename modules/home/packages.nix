{ lib, config, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) attrsOf package;
in
{
  options.nixfiles.packages = mkOption {
    type = attrsOf package;
    default = { };
    description = ''
      A set of packages to install in the nixfiles environment.
    '';
  };

  config = {
    home.packages = builtins.attrValues config.nixfiles.packages;
  };
}

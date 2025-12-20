{
  lib,
  localLib,
  config,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkOptionDefault;
  inherit (lib.types) nullOr enum;
  inherit (localLib.validators) hasProfile;
in
{
  options.nixfiles.environment.loginManager = mkOption {
    type = nullOr (enum [
      "sddm"
    ]);
    description = "The login manager to be used by the system.";
  };

  config = {
    nixfiles.environment.loginManager = mkOptionDefault (
      if (hasProfile config [ "graphical" ]) then "sddm" else null
    );
  };
}

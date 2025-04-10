{
  lib,
  self,
  config,
  osConfig,
  ...
}:
let
  inherit (lib.modules) mkOptionDefault;
  inherit (lib.attrsets) getAttrFromPath;
  inherit (lib.lists) elem;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool nullOr enum;
  inherit (self.lib.validators) hasProfile;

  mkMetaOption =
    path: enum:
    mkOption {
      default = elem (getAttrFromPath path config) enum;
      example = true;
      description = "Does ${enum} contain ${getAttrFromPath path}.";
      type = bool;
    };
in
{
  options.nixfiles = {
    environment.desktop = mkOption {
      type = nullOr (enum [
        "plasma6"
      ]);
      description = "The desktop environment ot use.";
    };

    meta = {
      isWayland = mkMetaOption [ "nixfiles" "environment" "desktop" ] [ "plasma6" ];
      isWM = mkMetaOption [ "nixfiles" "environment" "desktop" ] [ ];
    };
  };

  config.nixfiles = {
    environment.desktop = mkOptionDefault (
      if (hasProfile osConfig [ "graphical" ]) then "plasma6" else null
    );
  };
}

{
  lib,
  localLib,
  config,
  ...
}:
let
  inherit (lib.trivial) id;
  inherit (lib.options) mkOption;
  inherit (localLib.validators) anyHome;
  inherit (lib.strings) concatStringsSep;

  mkMetaOption =
    path:
    mkOption {
      default = anyHome config id path;
      example = true;
      description = "Is ${concatStringsSep "." path} true on any home for this system?";
      type = lib.types.bool;
    };
in
{
  options.nixfiles.meta = {
    zsh = mkMetaOption [
      "nixfiles"
      "programs"
      "zsh"
      "enable"
    ];
    fish = mkMetaOption [
      "nixfiles"
      "programs"
      "fish"
      "enable"
    ];
    isWayland = mkMetaOption [
      "nixfiles"
      "meta"
      "isWayland"
    ];
    isWM = mkMetaOption [
      "nixfiles"
      "meta"
      "isWM"
    ];
    plasma6 =
      let
        path = [
          "nixfiles"
          "environment"
          "desktop"
        ];
      in
      mkOption {
        default = anyHome config (v: v == "plasma6") path;
        example = true;
        description = "Is ${concatStringsSep "." path} true on any home for this system?";
        type = lib.types.bool;
      };
  };
}

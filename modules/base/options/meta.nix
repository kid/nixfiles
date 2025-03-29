{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.trivial) id;
  inherit (lib.options) mkOption;
  inherit (self.lib.validators) anyHome;
  inherit (lib.strings) concatStringsSep;

  mkMetaOption =
    path:
    mkOption {
      default = anyHome config id path;
      example = true;
      description = "Does ${concatStringsSep "." path} meet the requirements";
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
  };
}

{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.options) mkEnableOption mkOption;
in
{
  options.nixfiles.storage = {
    type = mkOption {
      type = types.nullOr (types.enum [ "btrfs" ]);
      default = null;
    };

    enableDisko = mkEnableOption "Disko integration";

    mainDevice = mkOption {
      type = types.str;
    };

    extraSubVolumes = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };
}

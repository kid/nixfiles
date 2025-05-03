{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.options) mkOption;
in
{
  options.nixfiles.storage = {
    type = mkOption {
      type = types.nullOr (types.enum [ "btrfs" ]);
      default = null;
    };

    mainDevice = mkOption {
      type = types.str;
    };

    extraSubVolumes = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };
}

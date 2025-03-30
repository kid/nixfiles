{
  lib,
  config,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  cfg = config.nixfiles.services.xremap;
in
{
  options.nixfiles.services.xremap.enable = mkEnableOption "xremap";

  config.services.xremap = {
    inherit (cfg) enable;
  };
}

{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixfiles.archetypes.gaming;
in
{
  options.nixfiles.archetypes.gaming.enable = mkEnableOption "gaming";

  config = mkIf cfg.enable {
    nixfiles.suites = {
      common.enable = true;
      desktop.enable = true;
    };
  };
}

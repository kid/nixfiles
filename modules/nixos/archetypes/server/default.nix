{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixfiles.archetypes.server;
in
{
  options.nixfiles.archetypes.server.enable = mkEnableOption "gaming";

  config = mkIf cfg.enable {
    nixfiles = {
      suites = {
        common.enable = true;
        server.enable = true;
      };
    };
  };
}

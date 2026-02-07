{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.nixfiles.theme.stylix;
in
{
  config = mkIf cfg.enable {
    stylix.targets = {
      qt.enable = false;
    };
  };
}

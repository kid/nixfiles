{
  lib,
  config,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.nixfiles.programs.gaming =
    let
      cfg = config.nixfiles.programs.gaming;
    in
    {
      enable = mkEnableOption "gaming";
      mangohud.enable = mkEnableOption "mangohud" {
        default = cfg.enable;
      };
    };
}

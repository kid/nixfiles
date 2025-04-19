{
  lib,
  config,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (config.nixfiles.programs) defaults;
  cfg = config.nixfiles.services.xremap;
in
{
  options.nixfiles.services.xremap.enable = mkEnableOption "xremap";

  config.services.xremap = {
    inherit (cfg) enable;
    withKDE = true;
    watch = true;

    config.keymap = [
      {
        remap = {
          SUPER-B = {
            launch = [ defaults.browser ];
          };
          SUPER-SHIFT-B = {
            launch = [
              defaults.browser
              "--private-window"
            ];
          };
          SUPER-T = {
            launch = [ defaults.terminal ];
          };
          SUPER-P = {
            launch = [ defaults.launcher ];
          };
        };
      }
    ];
  };
}

{
  localLib,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    ;
  inherit (lib.types) raw;
  inherit (localLib) mkBoolOpt;
in
{
  options.nixfiles.system.boot = {
    enable = mkEnableOption "boot";
    plymouth = mkBoolOpt true "Whether to enable the Plymouth boot splash";
    silent = mkBoolOpt true "Whether to enable silent boot";
    rememberLast = mkBoolOpt false "Whether to remember the last selected boot";

    kernel = mkOption {
      type = raw;
      default = pkgs.linuxPackages_latest;
    };

    secureBoot = mkEnableOption "secureBoot";
  };
}

{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum listOf;
in
{
  options.nixfiles.device.profiles = mkOption {
    default = [ ];
    type = listOf (enum [
      "laptop"
      "desktop"
      "server"
      "vm"

      "graphical"
      "headless"
    ]);
  };
}

{ lib, ... }:
let
  nixfilesLib = lib.fixedPoints.makeExtensible (final: {
    # NOTE: legacy
    module = import ./module { inherit lib; };

    helpers = import ./helpers.nix { inherit lib; };
    programs = import ./programs.nix { inherit lib; };
    hardware = import ./hardware.nix;
    validators = import ./validators.nix { inherit lib; };

    inherit (final.module) mkOpt mkBoolOpt;
    inherit (final.validators) ifTheyExists hasProfile;
  });
in
{
  flake.lib = nixfilesLib;
}

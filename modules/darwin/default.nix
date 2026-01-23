localFlake:
{ inputs', ... }:
let
  inherit (localFlake.nixfiles.lib.helpers) listImportableRecursive;
in
{
  _module.args = {
    localLib = localFlake.nixfiles.lib;
    inherit (localFlake) nixfiles;
    inherit inputs';
  };

  imports =
    with localFlake.inputs;
    [
      home-manager.darwinModules.default
      stylix.darwinModules.stylix
    ]
    ++ listImportableRecursive ../base
    ++ listImportableRecursive ./.;
}

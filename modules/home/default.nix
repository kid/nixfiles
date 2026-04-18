localFlake:
let
  inherit (localFlake.nixfiles.lib.helpers) listImportableRecursive;
in
{
  _module.args = {
    localLib = localFlake.nixfiles.lib;
  };

  imports =
    with localFlake.inputs;
    [
      plasma-manager.homeModules.plasma-manager
      sops-nix.homeManagerModules.sops
      xremap.homeManagerModules.default
    ]
    # ++ listImportableRecursive ../base
    ++ listImportableRecursive ./.;
}

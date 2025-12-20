localFlake:
let
  inherit (localFlake.self.lib.helpers) listImportableRecursive;
in
{
  _module.args = {
    localLib = localFlake.self.lib;
  };

  imports = listImportableRecursive ./.;
}

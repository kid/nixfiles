{ self, ... }:
let
  inherit (self.lib.helpers) listImportableRecursive;
in
{
  imports = listImportableRecursive ./.;
}

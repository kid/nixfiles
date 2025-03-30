{ lib }:
let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) flatten;
  inherit (lib.strings) hasSuffix;

  /**
    Generate a list of importable paths, stops is fa default.nix file is found

    # Arguments

    - [dir] the directory to search for nix files

    # Type

    ```
    listImportableRecursive :: String -> List
    ```

    # Example

    ```nix
    listImportableRecursive ./modules
    => [ "base" "flake-module.nix" "home" "nixos" ]
    ```
  */
  listImportableRecursive =
    dir:
    flatten (
      mapAttrsToList (
        name: type:
        if type == "directory" && builtins.pathExists "${dir}/${name}/default.nix" then
          "${dir}/${name}"
        else if type == "directory" then
          listImportableRecursive "${dir}/${name}"
        else if hasSuffix ".nix" name && name != "default.nix" then
          "${dir}/${name}"
        else
          [ ]
      ) (builtins.readDir dir)
    );
in
{
  inherit listImportableRecursive;
}

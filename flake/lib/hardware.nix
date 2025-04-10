let
  /**
    ldTernary, short for linux darwin ternary

    # Inputs

    - [pkgs] is the package set
    - [l] the value to return if the host platform is linux
    - [d] the value to return if the host platform is darwin

    # Type

    ```
    ldTernary :: AttrSet -> Any -> Any -> Any
    ```

    # Example

    ```nix
    ldTernary pkgs "linux" "darwin"
    => "linux"
    ```
  */
  ldTernary =
    pkgs: l: d:
    if pkgs.stdenv.hostPlatform.isLinux then
      l
    else if pkgs.stdenv.hostPlatform.isDarwin then
      d
    else
      throw "Unsupported system: ${pkgs.stdenv.system}";
in
{
  inherit ldTernary;
}

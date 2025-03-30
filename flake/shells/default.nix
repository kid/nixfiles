{ inputs, ... }:
{
  imports = [
    inputs.make-shell.flakeModules.default
  ];

  perSystem =
    _:
    let
      flake = {
        imports = [ ./flake.nix ];
      };
    in
    {

      make-shells = {
        inherit flake;

        default = flake;
      };
    };
}

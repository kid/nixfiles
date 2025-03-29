{ inputs, ... }:
{
  imports = [
    inputs.make-shell.flakeModules.default
  ];

  perSystem =
    _:
    let
      flake = {
        imports = [ ../shells/flake ];
      };
    in
    {

      make-shells = {
        inherit flake;

        default = flake;
      };
    };
}

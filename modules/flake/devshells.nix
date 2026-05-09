{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            nh
            nil
            nixd
            deadnix
            statix
          ];

          inputsFrom = [ config.treefmt.build.devShell ];
        };
      };
    };
}

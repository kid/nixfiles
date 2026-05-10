{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            just

            nh
            nil
            nixd
          ];

          inputsFrom = [ config.treefmt.build.devShell ];
        };
      };
    };
}

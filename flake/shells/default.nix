{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {

        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            just

            sops
            act

            nil
            nixd
            deadnix
            statix

            nix-melt

            # inputs.self.checks.${system}.pre-commit-hooks.enabledPackages
          ];

          inputsFrom = [ config.treefmt.build.devShell ];
        };
      };
    };
}

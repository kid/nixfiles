{
  perSystem =
    {
      config,
      pkgs,
      inputs',
      ...
    }:
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
            inputs'.disko.packages.disko-install
          ];

          inputsFrom = [ config.treefmt.build.devShell ];
        };
      };
    };
}

{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = ".git/config";
      enableDefaultExcludes = true;

      programs = {
        nixfmt = {
          enable = true;
          includes = [ "**/*.nix" ];
        };
        deadnix = {
          enable = true;
          no-underscore = true;
        };
        statix.enable = true;
        jsonfmt.enable = true;
        yamlfmt.enable = true;
        shfmt.enable = true;
        prettier.enable = true;
      };

      settings = {
        on-unmatched = "warn";
        global.excludes = [
          "vendor/**"
        ];
      };
    };

  };
}

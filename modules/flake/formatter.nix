{ inputs, ... }:
{
  flake-file.inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = ".git/config";
      enableDefaultExcludes = true;

      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
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

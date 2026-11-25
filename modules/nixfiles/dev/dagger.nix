{ nf, ... }:
{
  flake-file.inputs.dagger = {
    url = "github:dagger/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nf.dev.dagger = {
    includes = [ nf.dev.docker ];

    homeManager =
      { inputs', ... }:
      {
        home.packages = [ inputs'.dagger.packages.dagger ];
      };
  };
}

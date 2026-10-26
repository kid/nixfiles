{ nf, ... }:
{
  nf.dev.dagger = {
    includes = [ nf.dev.docker ];

    homeManager =
      { self', ... }:
      {
        home.packages = [ self'.packages.dagger ];
      };
  };
}

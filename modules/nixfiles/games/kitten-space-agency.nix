{
  nf.games.kitten-space-agency = {
    homeManager =
      { self', ... }:
      {
        home.packages = [ self'.packages.kitten-space-agency ];
      };
  };
}

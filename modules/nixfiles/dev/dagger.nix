{ inputs, nf, ... }:
{
  nf.dev.dagger = {
    includes = [ nf.dev.docker ];

    os = {

      nixpkgs.overlays = [ inputs.dagger.overlays.default ];
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          dagger
          container-use
        ];
      };
  };
}

{ inputs, ... }:
{
  nf.apps.neovim = {
    os.nixpkgs.overlays = [ inputs.neovim-flake.overlays.default ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ my-neovim ];
      };
  };
}

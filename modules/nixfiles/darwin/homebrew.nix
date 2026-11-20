{ inputs, ... }:
{
  flake-file.inputs = {
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;

    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
  };

  nf.darwin.homebrew =
    { user }:
    {
      darwin =
        { config, ... }:
        {
          imports = [
            inputs.nix-homebrew.darwinModules.nix-homebrew
          ];

          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = user.name;
            mutableTaps = false;

            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
            };
          };

          homebrew = {
            enable = true;

            # srvos' darwin profile sets onActivation.cleanup = "uninstall", which untaps anything not in the Brewfile.
            taps = builtins.attrNames config.nix-homebrew.taps;

            brews = [
              "pkg-config"
              "cairo"
              "pango"
              "libpng"
              "jpeg"
              "giflib"
              "librsvg"
              "pixman"
            ];

            casks = [
              "1password"
              "pgadmin4"
              "rectangle"
              "scroll-reverser"
              "amethyst"
            ];
          };
        };

      homeManager = {
        programs.zsh.initContent = ''
          eval "$(/opt/homebrew/bin/brew shellenv)"
        '';
      };
    };
}

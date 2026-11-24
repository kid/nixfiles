{ inputs, ... }:
let
  # nix-homebrew's bundled brew lags homebrew-core; formulae break when core uses newer DSL.
  brewVersion = "7.0.16";
in
{
  flake-file.inputs = {
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    brew-src.url = "github:Homebrew/brew/${brewVersion}";
    brew-src.flake = false;

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
            package = inputs.brew-src // {
              name = "brew-${brewVersion}";
              version = brewVersion;
            };

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

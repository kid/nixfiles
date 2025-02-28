{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule mkOpt;
in
mkModule ./. false config
  {
    package = mkOpt lib.types.package pkgs.nixVersions.latest "Which nix package to use.";
  }
  (cfg: {
    documentation = {
      man.generateCaches = true;

      nixos = {
        options = {
          warningsAreErrors = true;
          splitBuild = true;
        };
      };
    };

    nix =
      let
        users = [
          "root"
          "@wheel"
          "nix-builder"
        ];
      in
      {
        inherit (cfg) package;

        distributedBuilds = true;

        gc = {
          automatic = true;
          options = "--delete-older-than 7d";
        };

        optimise.automatic = true;

        settings = {
          allowed-users = users;
          trusted-users = users;

          auto-optimise-store = pkgs.stdenv.isLinux;

          experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];

          substituters = [
            "https://cache.nixos.org"
            "https://kidibox.cachix.org"
            "https://nix-community.cachix.org"
            "https://hyprland.cachix.org"
            "https://devenv.cachix.org"
            "https://nixpkgs-wayland.cachix.org"
            "https://cosmic.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "kidibox.cachix.org-1:BN875x9JUW61souPxjf7eA5Uh2k3A1OSA1JIb/axGGE="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          ];

          use-xdg-base-directories = true;
        };

        generateNixPathFromInputs = true;
        generateRegistryFromInputs = true;
        linkInputs = true;
      };
  })

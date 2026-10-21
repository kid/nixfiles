# Auto-loads pkgs/by-name/<name>/package.nix as packages.<name>, same
# directory shape as nixpkgs' own pkgs/by-name (minus its two-letter
# nesting) — for local packages not in nixpkgs.
{ inputs, ... }:
{
  flake-file.inputs.pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];

  perSystem =
    { system, ... }:
    {
      # Unfree packages (e.g. kitten-space-agency) must evaluate under `nix flake check`.
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgsDirectory = ../../pkgs/by-name;
      # Keeps linux-only packages out of packages.aarch64-darwin.
      pkgsFilterByPlatforms = true;
    };
}

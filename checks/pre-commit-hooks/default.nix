{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) git-hooks-nix;
in
git-hooks-nix.lib.${pkgs.system}.run {
  src = ./.;
  hooks = {
    treefmt = {
      enable = true;
      packageOverrides.treefmt = inputs.treefmt-nix.lib.mkWrapper pkgs ../../treefmt.nix;
    };
  };
}

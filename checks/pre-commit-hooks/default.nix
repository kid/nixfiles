{
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (inputs) git-hooks-nix treefmt-nix;
  treefmt = treefmt-nix.lib.evalModule pkgs ../../treefmt.nix;
in
git-hooks-nix.lib.${pkgs.system}.run {
  src = ./.;
  hooks = {
    treefmt = {
      # enable = true;
      package = treefmt.config.build.wrapper;
    };
  };
}

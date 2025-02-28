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
    # nixfmt-rfc-style = {
    #   enable = true;
    # };

    deadnix = {
      enable = true;
      # settings = {
      #   edit = true;
      # };
    };

    # git-cliff = {
    #   enable = false;
    # };

    shfmt.enable = true;

    statix.enable = true;

    treefmt = {
      enable = false;
      packageOverrides.treefmt = inputs.treefmt-nix.lib.mkWrapper pkgs ../../../treefmt.nix;
    };
  };
}

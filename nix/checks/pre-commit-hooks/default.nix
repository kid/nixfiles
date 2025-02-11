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
    nixfmt = {
      enable = true;
    };

    deadnix = {
      enable = true;
      settings = {
        edit = true;
      };
    };

    git-cliff = {
      enable = false;
    };

    shfmt.enable = true;

    statix.enable = true;

    # pre-commit-hook-ensure-sops-enable = true;
    treefmt = {
      enable = false;
      # settings.fail-on-change = true;
      # programs = {
      #   nixfmt.enable = true;
      #   nixfmt.package = pkgs.nixfmt-rfc-style;
      # };
    };
  };
}

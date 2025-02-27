{
  inputs,
  mkShell,
  pkgs,
  system,
  ...
}:
mkShell {
  packages = with pkgs; [
    fd
    just
    nil

    act

    deadnix
    nix-inspect
    nix-bisect
    nix-diff
    nix-health
    nix-index
    nix-melt
    nix-melt
    nix-prefetch-git
    nix-search-cli
    nix-tree
    nixpkgs-hammering
    nixpkgs-lint
    statix

    inputs.self.checks.${system}.pre-commit-hooks.enabledPackages
  ];

  shellHook = ''
    ${inputs.self.checks.${system}.pre-commit-hooks.shellHook}
  '';
}

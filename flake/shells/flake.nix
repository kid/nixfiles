{
  # config,
  pkgs,
  ...
}:
{
  packages = with pkgs; [
    just

    sops
    act

    nil
    nixd
    deadnix
    statix

    # inputs.self.checks.${system}.pre-commit-hooks.enabledPackages
  ];

  # inputsFrom = [ config.treefmt.build.devShell ];

  # shellHook = ''
  #   ${inputs.self.checks.${system}.pre-commit-hooks.shellHook}
  # '';
}

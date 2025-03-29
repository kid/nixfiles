{
  imports = [
    ../lib/flake-module.nix
    ../modules/flake-module.nix
    ../shells/flake-module.nix
    ../systems/flake-module.nix
  ];

  systems = [
    "x86_64-linux"
  ];

  flake = {
    herculesCI = {
      ciSystems = [ "x86_64-linux" ];
    };
  };
}

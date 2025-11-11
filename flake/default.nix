{
  imports = [
    ./checks/formatting.nix
    ./lib
    ./modules.nix
    ./programs/treefmt.nix
    ./shells
    ./systems.nix
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

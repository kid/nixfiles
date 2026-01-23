localFlake: {
  flake = {
    darwinModules.nixfiles = import ../modules/darwin localFlake;
    nixosModules.nixfiles = import ../modules/nixos localFlake;
    homeModules.nixfiles = import ../modules/home localFlake;
  };
}

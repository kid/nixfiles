localFlake: {
  flake = {
    nixosModules.nixfiles = import ../modules/nixos localFlake;
    homeModules.nixfiles = import ../modules/home localFlake;
  };
}

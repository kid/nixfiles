{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Determinate 3.* module
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules = {
    darwin.determinate = {
      imports = [ inputs.determinate.darwinModules.default ];
      nix.enable = false; # Determinate Nix handles the Nix configuration
    };
    nixos.determinate = {
      imports = [ inputs.determinate.nixosModules.default ];
      nix.enable = false; # Determinate Nix handles the Nix configuration
    };
  };
}

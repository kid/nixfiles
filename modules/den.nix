{ inputs, den, ... }:
{
  flake-file.inputs = {
    den.url = "github:denful/den";
    flake-file.url = "github:denful/flake-file";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
    (inputs.den.namespace "nf" true)
  ];

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  den.schema.user.includes = [ den._.mutual-provider ];
}

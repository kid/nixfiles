{ inputs, ... }:
{
  flake-file.inputs = {
    ucodenix.url = "github:e-tho/ucodenix";
  };

  nf.base.nixos = {
    imports = [ inputs.ucodenix.nixosModules.default ];

    services.ucodenix.enable = true;
  };
}

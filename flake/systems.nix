{
  withSystem,
  self,
  inputs,
  config,
  ...
}:
let
  inherit (inputs) nixpkgs;

  mkSystem =
    system: hostName:
    (withSystem system (
      let
        arch = builtins.elemAt (builtins.split "-" system) 0;
      in
      {
        system,
        self',
        inputs',
        ...
      }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            self
            self'
            inputs
            inputs'
            ;
          inherit (config) flake;
        };
        modules = [
          {
            networking = {
              inherit hostName;
            };
          }
          ../systems/${arch}-nixos/${hostName}
        ];
      }
    ));
in
{
  flake.nixosConfigurations = {
    fw13 = mkSystem "x86_64-linux" "fw13";
    vulkan = mkSystem "x86_64-linux" "vulkan";
  };
}

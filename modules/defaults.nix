{ den, lib, ... }:
{
  den = {
    default = {
      includes = [
        den.batteries.inputs'
        den.batteries.self'
      ];

      nixos.system.stateVersion = lib.mkDefault "25.05";
      homeManager.home.stateVersion = lib.mkDefault "25.05";
      darwin.system.stateVersion = lib.mkDefault 6;
    };

    schema.user.classes = lib.mkDefault [ "homeManager" ];
  };
}

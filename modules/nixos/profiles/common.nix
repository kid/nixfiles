{
  lib,
  localLib,
  config,
  ...
}:
let
  inherit (lib.modules) mkDefault mkMerge mkIf;
  inherit (localLib.validators) hasProfile;
in
{
  # TODO: get rid of this
  config = mkMerge [
    {
      nixfiles = {
        system.boot.enable = mkDefault true;
      };
    }
    (mkIf
      (
        (hasProfile config [ "desktop" ])
        || hasProfile config [ "laptop" ]
        || hasProfile config [ "server" ]
      )
      {
        nixfiles = {
          theme.stylix.enable = mkDefault true;
          hardware = {
            power.enable = mkDefault true;
          };
          security.sops.enable = mkDefault true;
        };
      }
    )
  ];
}

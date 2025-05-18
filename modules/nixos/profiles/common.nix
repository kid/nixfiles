{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.modules) mkDefault mkMerge mkIf;
  inherit (self.lib.validators) hasProfile;
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
            firmware.enable = mkDefault true;
            power.enable = mkDefault true;
          };
          security.sops.enable = mkDefault true;
        };
      }
    )
  ];
}

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
    (mkIf ((hasProfile config [ "desktop" ]) || hasProfile config [ "server" ]) {
      nixfiles = {
        # nix.enable = mkDefault true;
        theme.stylix.enable = mkDefault true;
        hardware = {
          firmware.enable = mkDefault true;
          power.enable = mkDefault true;
        };
        # system.env.enable = mkDefault true;
        security.sops.enable = mkDefault true;
      };
    })
  ];
}

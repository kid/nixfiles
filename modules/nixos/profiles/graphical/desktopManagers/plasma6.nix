{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixfiles) meta;
in
{
  config = mkIf meta.plasma6 {
    services.desktopManager.plasma6.enable = true;
    services.desktopManager.plasma6.enableQt5Integration = false;

    security.pam.services.sddm.kwallet.enable = true;
  };
}

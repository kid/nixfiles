{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixfiles.display-managers.sddm;
in
{
  options.nixfiles.display-managers.sddm.enable = mkEnableOption "sddm";
  config = mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings.General.DisplayServer = "wayland";
      };

      desktopManager.plasma6.enable = true;
    };
  };
}

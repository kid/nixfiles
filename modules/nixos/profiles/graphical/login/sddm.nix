{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.nixfiles) environment;
in
{
  config = mkIf (environment.loginManager == "sddm") {
    services.displayManager.sddm = {
      enable = true;

      wayland.enable = config.nixfiles.meta.isWayland;

      settings.General.InputMethod = "";
    };
  };
}

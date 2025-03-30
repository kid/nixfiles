{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config) nixfiles;
in
{
  config = mkIf (nixfiles.environment.loginManager == "sddm") {
    services.displayManager.autoLogin = {
      enable = nixfiles.security.autoLogin;
      user = nixfiles.system.mainUser;
    };
  };
}

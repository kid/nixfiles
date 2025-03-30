{
  lib,
  config,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) bool;
in
{
  options.nixfiles.security.autoLogin = mkOption {
    type = bool;
    default = false;
    description = "Automatically log in as {option}`nixfiles.system.mainUser`.";
  };

  config = mkIf config.nixfiles.security.autoLogin {
    services.getty.autologinUser = config.nixfiles.system.mainUser;
  };
}

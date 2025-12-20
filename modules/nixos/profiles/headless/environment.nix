{
  lib,
  localLib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (localLib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "headless" ]) {
    # print the URL instead on servers
    environment.variables.BROWSER = "echo";
  };
}

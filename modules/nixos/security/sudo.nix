{
  lib,
  ...
}:
let
  inherit (lib.modules) mkDefault;
in
{
  security = {
    sudo = {
      enable = true;

      wheelNeedsPassword = mkDefault false;

      # only allow members of the wheel group to execute sudo
      execWheelOnly = true;

      extraConfig = ''
        Defaults lecture = never
        Defaults pwfeedback
        Defaults env_keep += "EDITOR PATH DISPLAY"
        Defaults timestamp_timeout = 300
      '';
    };
  };
}

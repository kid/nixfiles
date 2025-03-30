{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib.validators) hasProfile;
in
{
  config = mkIf (hasProfile config [ "graphical" ]) {
    programs = {
      # we need dconf to interact with gtk
      # dconf.enable = true;

      nix-ld.enable = true;

      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ config.nixfiles.system.mainUser ];
      };
    };
  };
}

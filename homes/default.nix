{
  lib,
  config,
  self,
  self',
  inputs,
  inputs',
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) genAttrs;
  inherit (lib.options) mkEnableOption;
in
{
  options.nixfiles.system.useHomeManager = mkEnableOption "home-manager" // {
    default = true;
  };

  config = mkIf config.nixfiles.system.useHomeManager {
    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hm.old";

      # TODO: Should we discover users from file system instead of hardcoding in config.nixfiles.system.users?
      users = genAttrs config.nixfiles.system.users (name: {
        imports = [ "${self}/homes/${name}@${config.networking.hostName}" ];
      });

      extraSpecialArgs = {
        inherit
          self
          self'
          inputs
          inputs'
          ;
      };

      sharedModules = [ (self + /modules/home) ];
    };
  };
}

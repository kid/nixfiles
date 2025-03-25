{
  config,
  lib,
  options,
  ...
}:
with lib;
let
  inherit (lib.nixfiles) mkOpt;
in
{
  options.nixfiles.home = with types; {
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    file = mkOpt attrs { } "A set of files to be managed by home-manager's <option>home.file</option>.";
  };

  config = {
    nixfiles.home.extraOptions = {
      home.file = mkAliasDefinitions options.nixfiles.home.file;
      home.stateVersion = config.system.stateVersion;
      xdg.enable = true;
    };

    home-manager = {
      # enables backing up existing files instead of erroring if conflicts exist
      backupFileExtension = "hm.old";

      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.nixfiles.user.name} = mkAliasDefinitions options.nixfiles.home.extraOptions;

      verbose = true;
    };
  };
}

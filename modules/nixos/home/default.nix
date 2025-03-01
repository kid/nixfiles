{
  config,
  lib,
  options,
  namespace,
  ...
}:
let
  inherit (lib) types mkAliasDefinitions;
  inherit (lib.${namespace}) mkOpt;
in
{

  options.${namespace}.home = with types; {
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    file = mkOpt attrs { } "A set of files to be managed by home-manager's <option>home.file</option>.";
  };

  config = {
    ${namespace}.home.extraOptions = {
      home.file = mkAliasDefinitions options.${namespace}.home.file;
      home.stateVersion = config.system.stateVersion;
      xdg.enable = true;
    };

    home-manager = {
      # enables backing up existing files instead of erroring if conflicts exist
      backupFileExtension = "hm.old";

      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.${namespace}.user.name} = mkAliasDefinitions options.${namespace}.home.extraOptions;

      verbose = true;
    };
  };
}

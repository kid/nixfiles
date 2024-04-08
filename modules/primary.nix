{ config, lib, options, ... }: {
  options = {
    user = lib.mkOption {
      description = "Primary user configuration";
      type = lib.types.attrs;
      default = { };
    };

    hm = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = {
    home-manager.users.${config.user.name} = lib.mkAliasDefinitions options.hm;
    users.users.${config.user.name} = lib.mkAliasDefinitions options.user;
  };
}

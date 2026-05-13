{
  # TODO: should use schema instead?

  nf.batteries.privileged-user =
    { user, ... }:
    {
      nixos =
        { lib, config, ... }:
        {
          options.users.privilegedGroups = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };

          config.users.users.${user.userName}.extraGroups = config.users.privilegedGroups;
        };
    };
}

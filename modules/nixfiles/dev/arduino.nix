{
  nf.dev.arduino =
    { user, ... }:
    {
      nixos.users.users.${user.userName}.extraGroups = [ "dialout" ];

      homeManager =
        { pkgs, ... }:
        {
          home.packages = [ pkgs.arduino-ide ];
        };
    };
}

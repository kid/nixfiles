{
  localLib,
  config,
  ...
}:
let
  inherit (localLib.validators) hasProfile;
in
{
  programs.nh = {
    enable = !hasProfile config [ "server" ];

    clean = {
      enable = false;
      dates = "weekly";
    };
  };
}

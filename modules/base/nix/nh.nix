{
  self,
  config,
  ...
}:
let
  inherit (self.lib.validators) hasProfile;
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

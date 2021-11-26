{ config, lib, pkgs, ... }:

with lib;
with lib.modules;

{
  options = {
    user = {
      name = mkOption {
        type = types.str;
      };
    };
  };

  config = {
    nix.allowedUsers = [ "@wheel" ];
    nix.trustedUsers = [ "root" "@wheel" ];
    users.extraUsers.${config.user.name} = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "audio" "video" "wheel" ];
      initialPassword = "foo";
    };
  };
}

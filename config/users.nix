{ pkgs, ... }:
{
  users.extraUsers.kid = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["audio" "video" "sheel"];
    initialPassword = "foo";
  };
}

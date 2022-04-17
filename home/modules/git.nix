{ config, ... }:
{
  programs.git = {
    enable = true;
    delta.enable = true;
    userEmail = "arnaud.rebts@gmail.com";
    userName = "Arnaud Rebts";

    aliases = {
      co = "checkout";
    };
  };
}

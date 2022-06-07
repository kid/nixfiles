{ config, ... }:
{
  programs.git = {
    enable = true;
    delta.enable = true;
    userEmail = "arnaud.rebts@gmail.com";
    userName = "Arnaud Rebts";

    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      cl = "clone";
      cp = "cherry-pick";
      ls = "log --decorate --oneline";
      ll = "log --decorate --numstat";
      lg = "log --decorate --graph --abbrev-commit --date=relative --all";
      st = "status -s";
    };
  };
}

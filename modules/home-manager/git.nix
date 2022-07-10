{ config, ... }:
{
  programs.git = {
    enable = true;
    difftastic.enable = true;
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

    extraConfig = {
      fetch = {
        prune = true;
      };
      push = {
        default = "simple";
        followTags = true;
      };
      pull = {
        rebase = true;
      };
      merge = {
        ff = "only";
      };
      mergetool = {
        keepBackup = false;
      };
      rebase = {
        autosquash = true;
      };
      rerere = {
        enabled = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}

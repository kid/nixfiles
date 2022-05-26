{
  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "Arnaud Rebts";
    userEmail = "arnaud.rebts@gmail.com";

    aliases = {
      br = "branch";
      ci = "commit";
      cl = "clone";
      co = "checkout";
      cp = "cherry-pick";
      ls = "log --decorate --oneline";
      ll = "log --decorate --numstat";
      lg = "log --decorate --graph --abbrev-commit --date=relative --all";
      st = "status -s";
    };
  };
}

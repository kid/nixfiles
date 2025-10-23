{
  programs.git = {
    enable = true;

    settings = {
      difftastic.enable = true;

      user = {
        email = "arnaud.rebts@gmail.com";
        name = "Arnaud Rebts";
      };

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
        diffn = "diff --no-ext-diff";
      };

      extraConfig = {
        fetch = {
          prune = true;
        };
        push = {
          default = "simple";
          followTags = true;
          autoSetupRemote = true;
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
        user.signingkey = "~/.ssh/id_ed25519.pub";
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };
  };
}

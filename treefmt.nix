{
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    statix.enable = true;
    nixfmt.enable = true;
    prettier.enable = true;
    just.enable = true;
    shellcheck.enable = true;
    shfmt.enable = true;
    # Force use of editorconfig
    shfmt.indent_size = null;
  };

  settings = {
    global.excludes = [
      "LICENSE"
      # unsupported extensions
      "*.{gif,png,svg,tape,mts,lock,mod,sum,toml,env,envrc,org,yuck,gitignore,editorconfig}"
    ];

    formatter = {
      deadnix.priority = 1;
      statix.priority = 2;
      nixfmt.priotity = 3;
    };
  };
}

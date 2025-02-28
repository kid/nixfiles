{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    just.enable = true;
    statix.enable = true;
    shfmt = {
      enable = true;
      indent_size = 4;
    };
  };
}

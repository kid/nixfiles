{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
  };

  stylix.targets.nixvim.plugin = "base16-nvim";
}

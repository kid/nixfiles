{ inputs', ... }:
{
  home = {
    packages = with inputs'.neovim-flake.packages; [ neovim ];
    sessionVariables.EDITOR = "nvim";
    shellAliases.vimdiff = "nvim -d";
  };
}

{ pkgs, ...}:{
  home.packages = with pkgs; [
    neovim-nightly
    efm-langserver
    rnix-lsp
    shellcheck
  ];

  home.sessionVariables.EDITOR = "neovim";
}

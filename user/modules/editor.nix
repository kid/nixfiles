{ pkgs, ... }: {
  home.packages = with pkgs; [
    neovim-nightly

    # TODO move these into a "dev" module
    sumneko-lua-language-server
    efm-langserver
    rnix-lsp
    shellcheck
    shfmt
  ];

  home.sessionVariables.EDITOR = "nvim";

  home.sessionVariables.MANPAGER = "nvim +Man!";

  programs.zsh.localVariables.ZVM_VI_EDITOR = "nvim";
}

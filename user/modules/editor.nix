{ pkgs, ... }: {
  home.packages = with pkgs; [
    neovim-nightly
    efm-langserver
    rnix-lsp
    shellcheck
  ];

  home.sessionVariables.EDITOR = "nvim";

  home.sessionVariables.MANPAGER = "nvim +Man!";
  home.sessionVariables.MANWIDTH = "999";

  # FIXME this should use $EDITOR
  # Either EDITOR is not set early enough, or a new session is needed?
  programs.zsh.localVariables.ZVM_VI_EDITOR = "nvim";
}

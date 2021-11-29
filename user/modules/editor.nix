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

  programs.zsh.localVariables.ZVM_VI_EDITOR = "nvim";
}

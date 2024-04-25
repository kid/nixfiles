{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = lib.mkIf (!config.programs.nixvim.enable) {
    shellAliases.nvim = "NVIM_APPNAME=nvim-astrov4 nvim";
    sessionVariables.EDITOR = "nvim";
    sessionVariables.MANPAGER = "nvim +Man!";
    packages = with pkgs; [
      neovim

      # required for building treesitter modules
      gcc

      # TODO move these into a "dev" module
      sumneko-lua-language-server
      efm-langserver
      shellcheck
      shfmt
    ];
  };

  programs.zsh.localVariables.ZVM_VI_EDITOR = "nvim";
}

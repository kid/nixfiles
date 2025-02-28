{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = lib.mkIf (!config.programs.nixvim.enable) {
    sessionVariables = {
      EDITOR = "nvim";
      NVIM_APPNAME = "nvim-astrov4";
      MANPAGER = "nvim +Man!";
    };
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

  programs.helix.enable = true;

  programs.zsh.localVariables.ZVM_VI_EDITOR = "nvim";
}

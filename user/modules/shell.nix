{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    git
    htop
  ];

  programs.htop.enable = true;

  programs.exa.enable = true;
  programs.exa.enableAliases = true;

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    localVariables = {
      ZVM_VI_INSERT_ESCAPE_BINDKEY = "jk";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
        { name = "plugins/fancy-ctrl-z"; tags = [ from:oh-my-zsh ]; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "agkozak/zsh-z"; }
        { name = "jeffreytse/zsh-vi-mode"; }
      ];
    };
  };
} 

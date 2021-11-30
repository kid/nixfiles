{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    git
    htop
    fd
    ripgrep
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
  programs.fzf.defaultCommand = "fd --type f";
  programs.fzf.fileWidgetCommand = "fd --type f";

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    localVariables = {
      ZVM_VI_INSERT_ESCAPE_BINDKEY = "jk";
      ZVM_INIT_MODE = "sourcing";
    };
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      share = false;
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
        { name = "plugins/fancy-ctrl-z"; tags = [ from:oh-my-zsh ]; }
        { name = "Aloxaf/fzf-tab"; tags = [ "defer:1" ]; }
        { name = "agkozak/zsh-z"; }
      ];
    };
  };
} 

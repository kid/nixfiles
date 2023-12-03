{ pkgs, ... }: {
  home.packages = with pkgs; [
    fd
    htop
    jq
    ripgrep
    helix
  ];

  programs.gh.enable = true;
  programs.gh.settings.git_protocol = "ssh";

  programs.htop.enable = true;

  programs.bat.enable = true;
  programs.bat.config.theme = "gruvbox-dark";

  programs.eza.enable = true;
  programs.eza.enableAliases = true;

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
    initExtra = ''
      setopt inc_append_history
    '';
    shellAliases = {
      ssh = "TERM=xterm-256color ssh";
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

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    htop
    jq
    ripgrep
    pistol # For previews in lf
    gnumake
    gopls
    devenv
  ];
  programs = {
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
      settings.version = 1;
    };

    htop.enable = true;
    btop.enable = true;
    bottom.enable = true;

    bat.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fish.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
    };

    k9s.enable = true;

    zsh = {
      enable = true;
      autocd = true;
      enableVteIntegration = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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

        source "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
        source "${pkgs.fzf}/share/fzf/key-bindings.zsh"

        _zsh_cli_fg() { fg; }
        zle -N _zsh_cli_fg
        bindkey '^Z' _zsh_cli_fg

        function set_win_title(){
          echo -ne "\033]0; $(basename "$PWD") \007"
        }

        precmd_functions+=(set_win_title)

        source "${pkgs.kubectl}/share/zsh/site-functions/_kubectl"
      '';

      # shellAliases = {
      #   ssh = "TERM=xterm-256color ssh";
      # };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    lf = {
      enable = true;
    };
  };
}

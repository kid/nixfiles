{
  __findFile,
  ...
}:
{
  nf.shell.zsh = {
    includes = [ <nf.shell> ];

    homeManager =
      { config, pkgs, ... }:
      {
        home.shell = {
          enableShellIntegration = false;
          enableBashIntegration = false;
          enableIonIntegration = false;
          enableNushellIntegration = false;
          enableZshIntegration = true;
          enableFishIntegration = false;
        };

        programs.zsh = {
          enable = true;
          autocd = true;
          enableCompletion = true;
          enableVteIntegration = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          localVariables = {
            ZVM_VI_INSERT_ESCAPE_BINDKEY = "jk";
            ZVM_INIT_MODE = "sourcing";
          };
          history = {
            append = true;
            expireDuplicatesFirst = true;
            extended = true;
            ignoreDups = true;
            share = false;
          };
          shellAliases = {
            g = "git";
            k = "kubectl";
          };
          plugins = [
            {
              name = "zsh-vi-mode";
              src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
            }
            {
              name = "fzf-tab";
              src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
            }
          ];
          initContent = ''
            _zsh_cli_fg() { fg; }
            zle -N _zsh_cli_fg
            bindkey '^Z' _zsh_cli_fg

            function set_win_title(){
              echo -ne "\033]0; $(basename "$PWD") \007"
            }

            precmd_functions+=(set_win_title)

            if [ -d "$HOME/go/bin" ]; then
              export PATH="$HOME/go/bin:$PATH"
            fi
          '';
        };
      };
  };
}

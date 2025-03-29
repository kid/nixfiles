{
  pkgs,
  ...
}:
{
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;

      completionInit = # bash
        ''
          # Load compinit
          autoload -U compinit
          zmodload zsh/complist

          _comp_options+=(globdots)
          zcompdump="$XDG_DATA_HOME"/zsh/.zcompdump-"$ZSH_VERSION"-"$(date --iso-8601=date)"
          compinit -d "$zcompdump"

          # Recompile zcompdump if it exists and is newer than zcompdump.zwc
          # compdumps are marked with the current date in yyyy-mm-dd format
          # which means this is likely to recompile daily
          # also see: <https://htr3n.github.io/2018/07/faster-zsh/>
          if [[ -s "$zcompdump" && (! -s "$zcompdump".zwc || "$zcompdump" -nt "$zcompdump".zwc) ]]; then
            zcompile "$zcompdump"
          fi

          # Load bash completion functions.
          autoload -U +X bashcompinit && bashcompinit
        '';

      dotDir = ".config/zsh";

      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting = {
        enable = true;
      };
      # initExtraFirst = # bash
      #   ''
      #     # avoid duplicated entries in PATH
      #     typeset -U PATH
      #
      #     # try to correct the spelling of commands
      #     setopt correct
      #     # disable C-S/C-Q
      #     setopt noflowcontrol
      #     # disable "no matches found" check
      #     unsetopt nomatch
      #
      #     # autosuggests otherwise breaks these widgets.
      #     # <https://github.com/zsh-users/zsh-autosuggestions/issues/619>
      #     ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-beginning-search-backward-end history-beginning-search-forward-end)
      #
      #     # Do this early so fast-syntax-highlighting can wrap and override this
      #     if autoload history-search-end; then
      #       zle -N history-beginning-search-backward-end history-search-end
      #       zle -N history-beginning-search-forward-end  history-search-end
      #     fi
      #
      #     source <(${lib.getExe config.programs.fzf.package} --zsh)
      #     source ${config.programs.git.package}/share/git/contrib/completion/git-prompt.sh
      #
      #     # Prevent the command from being written to history before it's
      #     # executed; save it to LASTHIST instead.  Write it to history
      #     # in precmd.
      #     #
      #     # called before a history line is saved.  See zshmisc(1).
      #     function zshaddhistory() {
      #       # Remove line continuations since otherwise a "\" will eventually
      #       # get written to history with no newline.
      #       LASTHIST=''${1//\\$'\n'/}
      #       # Return value 2: "... the history line will be saved on the internal
      #       # history list, but not written to the history file".
      #       return 2
      #     }
      #
      #     # zsh hook called before the prompt is printed.  See zshmisc(1).
      #     function precmd() {
      #       # Write the last command if successful, using the history buffered by
      #       # zshaddhistory().
      #       if [[ $? == 0 && -n ''${LASTHIST//[[:space:]\n]/} && -n $HISTFILE ]] ; then
      #         print -sr -- ''${=''${LASTHIST%%'\n'}}
      #       fi
      #     }
      #   '';
      initExtra = # sh
        ''
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
      # plugins = [
      #   {
      #     # Must be before plugins that wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting
      #     name = "fzf-tab";
      #     file = "share/fzf-tab/fzf-tab.plugin.zsh";
      #     src = pkgs.zsh-fzf-tab;
      #   }
      #   {
      #     name = "zsh-nix-shell";
      #     file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      #     src = pkgs.zsh-nix-shell;
      #   }
      #   {
      #     name = "zsh-vi-mode";
      #     src = pkgs.zsh-vi-mode;
      #     file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      #   }
      #   {
      #     name = "fast-syntax-highlighting";
      #     file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      #     src = pkgs.zsh-fast-syntax-highlighting;
      #   }
      #   {
      #     name = "zsh-autosuggestions";
      #     file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      #     src = pkgs.zsh-autosuggestions;
      #   }
      #   {
      #     name = "zsh-better-npm-completion";
      #     src = pkgs.zsh-better-npm-completion;
      #   }
      #   {
      #     name = "zsh-command-time";
      #     src = pkgs.zsh-command-time;
      #   }
      #   {
      #     name = "zsh-history-to-fish";
      #     src = pkgs.zsh-history-to-fish;
      #   }
      #   {
      #     name = "zsh-you-should-use";
      #     src = pkgs.zsh-you-should-use;
      #   }
      # ];
    };
  };
}

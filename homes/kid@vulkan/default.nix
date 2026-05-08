{
  config,
  inputs,
  inputs',
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.sops-nix.homeManagerModules.sops
    inputs.xremap.homeManagerModules.default
  ];

  home = {
    stateVersion = osConfig.system.stateVersion;
    packages = [
      pkgs.incus
      pkgs.opencode
      pkgs.ollama-rocm
      inputs'.neovim-flake.packages.neovim
      pkgs.winbox4
      pkgs.fd
      pkgs.htop
      pkgs.jq
      pkgs.yq
      pkgs.ripgrep
      pkgs.pistol
      pkgs.gnumake
      pkgs.gopls
      pkgs.devenv
      pkgs.kubectl
      pkgs.talosctl
      pkgs.flux
      inputs'.dagger.packages.container-use
      inputs'.dagger.packages.dagger
      pkgs.xclip
      pkgs.chromium
      pkgs.discord
      pkgs.telegram-desktop
      pkgs.nfs-utils
      pkgs.pulsemixer
      pkgs.freecad
      pkgs.prusa-slicer
      pkgs.proton-pass
    ];

    sessionVariables.EDITOR = "nvim";
    shellAliases.vimdiff = "nvim -d";
  };

  systemd.user.startServices = lib.mkDefault "sd-switch";

  programs = {
    home-manager.enable = true;

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
      settings.version = 1;
    };

    htop.enable = true;
    btop.enable = true;
    bottom.enable = true;
    bat.enable = true;
    k9s.enable = true;
    lf.enable = true;
    kitty.enable = true;
    gh-dash.enable = true;
    zellij.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        compression = true;
        forwardAgent = true;
      };
    };

    firefox = {
      enable = true;
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        SearchBar = "unified";
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
      profiles.kid = {
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          sponsorblock
          ublock-origin
          consent-o-matic
          improved-tube
          sidebery
          onepassword-password-manager
          proton-pass
          plasma-integration
        ];

        search = {
          force = true;
          engines = {
            youtube = {
              name = "YouTube";
              definedAliases = [ "@yt" ];
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            github = {
              name = "GitHub";
              definedAliases = [ "@gh" ];
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            nix-packages = {
              name = "Nix Packages";
              definedAliases = [ "@np" ];
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            nixos-options = {
              name = "Nix Options";
              definedAliases = [ "@no" ];
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "options";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "@nw" ];
            };
            rottentomatoes = {
              name = "RottenTomatoes";
              definedAliases = [ "@rt" ];
              urls = [
                {
                  template = "https://www.rottentomatoes.com/search";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };

        settings = {
          "browser.sessionstore.resuming_after_os_restart" = true;
          "browser.sessionstore.restore_on_demand" = false;
          "browser.sessionstore.restore_pinned_tabs_on_demand" = false;
          "browser.startup.page" = 3;
          "browser.tabs.groups.enable" = true;
          "browser.tabs.tabMinWidth" = 85;
          "browser.urlbar.openintab" = false;
          "signon.rememberSignons" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
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

    git = {
      enable = true;
      settings = {
        difftastic.enable = true;
        user = {
          email = "arnaud.rebts@gmail.com";
          name = "Arnaud Rebts";
          signingkey = "~/.ssh/id_ed25519.pub";
        };
        fetch.prune = true;
        push = {
          default = "simple";
          followTags = true;
          autoSetupRemote = true;
        };
        pull.rebase = true;
        merge.ff = "only";
        mergetool.keepBackup = false;
        rebase.autosquash = true;
        rerere.enabled = true;
        init.defaultBranch = "main";
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
        alias = {
          co = "checkout";
          br = "branch";
          ci = "commit";
          cl = "clone";
          cp = "cherry-pick";
          ls = "log --decorate --oneline";
          ll = "log --decorate --numstat";
          lg = "log --decorate --graph --abbrev-commit --date=relative --all";
          st = "status -s";
          diffn = "diff --no-ext-diff";
        };
      };
    };

    ghostty = {
      enable = true;
      settings.keybind = [
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:bottom"
        "ctrl+shift+k=goto_split:top"
        "ctrl+shift+l=goto_split:right"
      ];
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        local function is_vim(pane)
          return pane:get_user_vars().IS_NVIM == 'true'
        end

        local direction_keys = {
          h = 'Left',
          j = 'Down',
          k = 'Up',
          l = 'Right',
        }

        local function split_nav(resize_or_move, key)
          return {
            key = key,
            mods = resize_or_move == 'resize' and 'META' or 'CTRL',
            action = wezterm.action_callback(function(win, pane)
              if is_vim(pane) then
                win:perform_action({
                  SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
                }, pane)
              else
                if resize_or_move == 'resize' then
                  win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                  win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
              end
            end),
          }
        end

        return {
          use_fancy_tab_bar = false,
          hide_tab_bar_if_only_one_tab = true,
          command_palette_font_size = 11,
          mux_enable_ssh_agent = false,
          keys = {
            split_nav('move', 'h'),
            split_nav('move', 'j'),
            split_nav('move', 'k'),
            split_nav('move', 'l'),
            split_nav('resize', 'h'),
            split_nav('resize', 'j'),
            split_nav('resize', 'k'),
            split_nav('resize', 'l'),
          },
        }
      '';
    };

    zed-editor = {
      enable = true;
      userSettings.vim_mode = true;
    };

    plasma = {
      enable = true;
      overrideConfig = true;
      powerdevil.AC = {
        dimDisplay.enable = false;
        turnOffDisplay.idleTimeout = "never";
      };
      fonts.general = {
        family = "JetBrains Mono";
        pointSize = 12;
      };
      panels = [
        {
          location = "top";
          widgets = [
            {
              name = "org.kde.plasma.kickoff";
              config.General.icon = "nix-snowflake-white";
            }
            {
              name = "org.kde.plasma.icontasks";
              config.General.launchers = [ "applications:steam.desktop" ];
            }
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.marginsseparator"
          ];
        }
      ];
      configFile.kwinrc.ModifierOnlyShortcuts.Meta = "";
      session = {
        general.askForConfirmationOnLogout = false;
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
      shortcuts.plasmashell."activate application launcher" = [ "Alt+F1" ];
    };
  };

  qt.platformTheme.name = lib.mkForce "kde";

  services.xremap = {
    enable = true;
    withKDE = true;
    watch = true;
    config.keymap = [
      {
        remap = {
          SUPER-B.launch = [ "firefox" ];
          SUPER-SHIFT-B.launch = [
            "firefox"
            "--private-window"
          ];
          SUPER-T.launch = [ "wezterm" ];
          SUPER-P.launch = [ "krunner" ];
        };
      }
    ];
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "application/json" = [ "nvim.desktop" ];
        "text/english" = [ "nvim.desktop" ];
        "text/plain" = [ "nvim.desktop" ];
        "text/x-makefile" = [ "nvim.desktop" ];
        "text/x-c++hdr" = [ "nvim.desktop" ];
        "text/x-c++src" = [ "nvim.desktop" ];
        "text/x-chdr" = [ "nvim.desktop" ];
        "text/x-csrc" = [ "nvim.desktop" ];
        "text/x-java" = [ "nvim.desktop" ];
        "text/x-moc" = [ "nvim.desktop" ];
        "text/x-pascal" = [ "nvim.desktop" ];
        "text/x-tcl" = [ "nvim.desktop" ];
        "text/x-tex" = [ "nvim.desktop" ];
        "application/x-shellscript" = [ "nvim.desktop" ];
        "text/x-c" = [ "nvim.desktop" ];
        "text/x-c++" = [ "nvim.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "audio/*" = [ "mpv.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/ftp" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-scheme-handler/discord" = [ "Discord.desktop" ];
      };
      defaultApplications = config.xdg.mimeApps.associations.added;
    };
    autostart = {
      enable = true;
      entries = [
        "${pkgs._1password-gui}/share/applications/1password.desktop"
        "${pkgs.telegram-desktop}/share/applications/org.telegram.desktop.desktop"
      ];
    };
  };

  home.shell = {
    enableShellIntegration = false;
    enableBashIntegration = false;
    enableIonIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = true;
    enableFishIntegration = false;
  };

  stylix.targets.firefox.profileNames = [ "kid" ];
}

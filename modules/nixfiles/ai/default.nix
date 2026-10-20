{ inputs, ... }:
{
  nf.ai = {
    os = {
      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };

      nixpkgs.overlays = [
        inputs.llm-agents.overlays.shared-nixpkgs
      ];
    };

    homeManager =
      { lib, pkgs, ... }:
      let
        lsp = {
          typescript = lib.getExe pkgs.typescript-language-server;
          go = lib.getExe pkgs.gopls;
          nix = lib.getExe pkgs.nixd;
        };
      in
      {
        imports = [ ./_omp.nix ];

        home = {
          packages =
            with pkgs.llm-agents;
            [
              opencode
            ]
            ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ claude-desktop ];
        };

        programs = lib.mkMerge [
          (lib.genAttrs
            [
              "claude-code"
              "codex"
              "omp"
            ]
            (name: {
              enable = true;
              enableMcpIntegration = true;
              package = pkgs.llm-agents.${name};
              context = builtins.readFile ./agents.md;
            })
          )
          {
            tmux.enable = true;

            claude-code = {
              settings = {
                editorMode = "vim";
                theme = "dark-ansi";
                env = {
                  CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = 1;
                };
                outputStyle = "ASD-STE100";
              };

              outputStyles.ASD-STE100 = ./asd-ste100.md;

              lspServers = {
                typescript = {
                  command = lsp.typescript;
                  args = [ "--stdio" ];
                  extensionToLanguage = {
                    ".ts" = "typescript";
                    ".mts" = "typescript";
                    ".cts" = "typescript";
                    ".tsx" = "typescriptreact";
                    ".js" = "javascript";
                    ".mjs" = "javascript";
                    ".cjs" = "javascript";
                    ".jsx" = "javascriptreact";
                  };
                };

                go = {
                  command = lsp.go;
                  args = [ "serve" ];
                  extensionToLanguage = {
                    ".go" = "go";
                  };
                };

                nix = {
                  command = lsp.nix;
                  extensionToLanguage = {
                    ".nix" = "nix";
                  };
                };
              };
            };

            codex.settings.tui.terminal_title = [
              "activity"
              "project"
              "thread-title"
              "git-branch"
              "context-remaining"
            ];

            omp = {
              settings = {
                github.enabled = true;
                memory.backend = "mnemopi";
                mnemopi.scoping = "global";
                theme = {
                  dark = "dark-gruvbox";
                  light = "light-gruvbox";
                };
              };

              lspServers = {
                typescript-language-server.command = lsp.typescript;
                gopls.command = lsp.go;
                nixd.command = lsp.nix;
              };
            };
          }
        ];
      };
  };
}

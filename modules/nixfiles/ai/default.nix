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
      {
        home = {
          packages =
            with pkgs.llm-agents;
            [
              opencode
            ]
            ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ claude-desktop ];
        };

        programs = lib.mkMerge [
          (lib.genAttrs [ "claude-code" "codex" ] (name: {
            enable = true;
            enableMcpIntegration = true;
            package = pkgs.llm-agents.${name};
            context = builtins.readFile ./agents.md;
          }))
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
                  command = lib.getExe pkgs.typescript-language-server;
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
                  command = lib.getExe pkgs.gopls;
                  args = [ "serve" ];
                  extensionToLanguage = {
                    ".go" = "go";
                  };
                };

                nix = {
                  command = lib.getExe pkgs.nixd;
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
          }
        ];
      };
  };
}

{
  nf.ai.claude = {
    homeManager =
      { lib, pkgs, ... }:
      {
        home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
          with pkgs.llm-agents; [ claude-desktop ]
        );

        programs.claude-code = {
          enable = true;
          enableMcpIntegration = true;
          package = pkgs.llm-agents.claude-code;

          context = ./agents.md;

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
      };
  };
}

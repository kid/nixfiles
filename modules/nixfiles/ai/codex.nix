{
  nf.ai.codex = {
    homeManager =
      { pkgs, ... }:
      {
        programs.codex = {
          enable = true;
          enableMcpIntegration = true;
          package = pkgs.llm-agents.codex;
          context = builtins.readFile ./agents.md;
          settings.tui.terminal_title = [
            "activity"
            "project"
            "thread-title"
            "git-branch"
            "context-remaining"
          ];
        };
      };
  };
}

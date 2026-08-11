{
  nf.ai.claude = {
    homeManager =
      { pkgs, ... }:
      {
        programs.tmux.enable = true;

        home = {
          sessionVariables = {
            CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = 1;
          };
        };

        programs.claude-code = {
          enable = true;
          enableMcpIntegration = true;
          package = pkgs.llm-agents.claude-code;
          settings = {
            editorMode = "vim";
            theme = "dark-ansi";
          };
        };
      };
  };
}

{
  nf.ai.claude = {
    homeManager =
      { config, pkgs, ... }:
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
          configDir = "${config.xdg.configHome}/claude";
          package = pkgs.llm-agents.claude-code;
        };
      };
  };
}

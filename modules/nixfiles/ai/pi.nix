{
  nf.ai.pi = {
    homeManager =
      { inputs', ... }:
      {
        home.packages = [
          inputs'.llm-agents.packages.pi
        ];
      };
  };
}

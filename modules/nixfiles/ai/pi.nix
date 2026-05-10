{
  nf.ai._.pi = {
    homeManager =
      { inputs', ... }:
      {
        home.packages = [
          inputs'.llm-agents.packages.pi
        ];
      };
  };
}

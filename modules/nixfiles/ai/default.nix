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
      { pkgs, ... }:
      {
        programs.tmux.enable = true;

        home = {
          packages = with pkgs.llm-agents; [
            opencode
          ];
        };
      };
  };
}

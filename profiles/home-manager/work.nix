{ pkgs, ... }:
{
  programs.git = {
    includes = [{
      condition = "gitdir:~/Code/wave2/";
      contents = {
        user.email = "arnaud.rebts@gmail.com";
        hub.host = "github.services.mckinseywave.com";
      };
    }];
  };

  home.packages = with pkgs; [
    kubectl
    kubectx
    kubie
    kubernetes-helm
    nodejs
    nodePackages.typescript-language-server
    yamllint
  ];
}

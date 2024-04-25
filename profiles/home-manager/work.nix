{ pkgs, ... }:
{
  programs.git = {
    includes = [
      {
        condition = "gitdir:~/Code/wave2/";
        contents = {
          user.email = "arnaud.rebts@gmail.com";
          hub.host = "github.services.mckinseywave.com";
        };
      }
    ];
  };

  home.packages = with pkgs; [
    awscli
    kubectl
    kubectx
    kubie
    kubernetes-helm
    helm-docs
    terraform-ls
    nodejs
    nodePackages.typescript-language-server
    yamllint
    go
    gopls
    golangci-lint
    argocd
    sops
    age
    pre-commit
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };
}

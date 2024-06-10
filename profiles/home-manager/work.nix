{ pkgs, ... }:
{
  programs.git = {
    includes = [
      {
        condition = "gitdir:~/Code/wave2/";
        contents = {
          user.email = "arnaud_rebts@mckinsey.com";
          hub.host = "github.services.mckinseywave.com";
        };
      }
    ];
  };

  home.packages = with pkgs; [
    awscli
    kubectl
    kubectl-cnpg
    kubectx
    kubie
    kubernetes-helm
    helm-docs
    terraform
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
    kind
    redis
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };
}

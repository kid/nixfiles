{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sops
    # azure-cli
    kubectl
    kubectx
    # kustomize
    # kustomize-sops
    # certbot-full
    winbox
    screen
    minicom
    go
    nil
    rnix-lsp
    nodejs
    unzip
    cargo
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sops
    azure-cli
    kubectl
    kubectx
    kustomize
    kustomize-sops
    certbot-full
    winbox
    screen
    minicom
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };
}
